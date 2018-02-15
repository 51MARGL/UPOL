/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package cv2.server;

import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.OutputStreamWriter;
import java.net.Socket;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.stream.Collectors;

/**
 *
 * @author Kudryashov
 */
class ServerThread extends Thread {

    private Socket clientSocket;
    private User currentUser = null;

    public ServerThread(Socket clientSocket) {
        this.clientSocket = clientSocket;
    }

    public void setCurrentUser(User u) {
        this.currentUser = u;
    }

    @Override
    public void run() {

        try (BufferedReader rd = new BufferedReader(new InputStreamReader(clientSocket.getInputStream()));
                BufferedWriter wr = new BufferedWriter(new OutputStreamWriter(clientSocket.getOutputStream()))) {

            while (true) {
                String response;
                String command = rd.readLine();
                if (isInterrupted()) {
                    sendResponse("DIS", wr);
                    break;
                }
                if (command.startsWith("CONNECT")) {
                    response = connect(command);
                } else if (command.startsWith("CHECK")) {
                    response = "CONNECTED";
                } else if (command.startsWith("READ")) {
                    response = read(wr, rd);
                } else if (command.startsWith("MSG FOR")) {
                    response = sendMSG(command);
                } else if (command.startsWith("!STOP")) { //only for admin
                    if (currentUser.getName().equals("admin")) {
                        response = "OK";
                        Cv2Server.stopServer = true;
                        Cv2Server.stopThreads();
                        sendResponse(response, wr);
                        break;
                    } else {
                        response = "ERR";
                    }
                } else if (command.startsWith("LOGOUT")) {
                    response = "OK";
                    sendResponse(response, wr);
                    break;
                } else {
                    response = "ERR";
                }
                sendResponse(response, wr);
            }
        } catch (Exception e) {
            System.out.println("Error:" + e.getMessage());
        } finally {
            try {
                clientSocket.close();
            } catch (IOException e) {
                System.out.println("Error:" + e.getMessage());
            }
        }
    }

    public User findUser(String name) {
        for (User u : Cv2Server.getUsers()) {
            if (u.getName().equals(name)) {
                return u;
            }
        }
        return null;
    }

    public void sendResponse(String response, BufferedWriter wr) throws IOException {
        wr.write(response);
        wr.write('\n');
        wr.flush();
    }

    public String connect(String command) {
        String[] tmp = command.split(" ");
        if (tmp.length > 2) {
            User found = findUser(tmp[1]);

            if (found != null) {
                if (tmp[2].equalsIgnoreCase(found.getPassword())) {
                    setCurrentUser(found);
                    return "OK";
                } else {
                    return "ERR";
                }
            } else {
                setCurrentUser(new User(tmp[1], tmp[2]));
                Cv2Server.addUser(currentUser);
                return "OK";
            }
        } else {
            return "ERR";
        }
    }

    public String read(BufferedWriter wr, BufferedReader rd) throws IOException {
        if (currentUser != null) {
            for (String m : currentUser.getMSG()) {
                sendResponse("FROM " + m, wr);
                if (!rd.readLine().startsWith("READ")) {
                    break;
                }
            }
            currentUser.clearMSG();
            return "OK";
        } else {
            return "ERR";
        }
    }

    public String sendMSG(String command) {
        ArrayList<String> tmp = new ArrayList(Arrays.asList(command.split(" ")));

        if (tmp.size() > 3) {
            User found = findUser(tmp.get(2).substring(0, tmp.get(2).length() - 1));

            if (found != null) {
                found.addMSG(currentUser.getName()
                        + ": "
                        + tmp.subList(3, tmp.size()).stream()
                        .collect(Collectors.joining(" ")));
                return "OK";
            } else {
                return "ERR";
            }
        } else {
            return "ERR";
        }
    }
}
