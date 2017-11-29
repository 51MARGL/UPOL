/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package cv.pkg2.client;

import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.OutputStreamWriter;
import java.net.Socket;
import java.util.Scanner;

/**
 *
 * @author Kudryashov
 */
public class Cv2Client {

    public static void sendCommand(String command, BufferedWriter wr) throws IOException {
        wr.write(command);
        wr.write('\n');
        wr.flush();
    }

    public static void start(BufferedReader rd, BufferedWriter wr, Scanner in)
            throws IOException {
        while (true) {
            String response;
            String command;
            System.out.println("ENTER COMMAND:");
            command = in.nextLine();   //v prvnim prochazeni se zapise prazdny retezec, a nevim proc.        
            sendCommand(command, wr); //Pak to funguje v poradku
            response = rd.readLine();
            while (response.startsWith("FROM")) {
                System.out.println(response);
                sendCommand(command, wr);
                response = rd.readLine();
            }
            if (response.startsWith("DIS")) {
                System.out.println("DISCONNECTED");
                break;
            }
            if (!response.startsWith("FROM")) {
                System.out.println(response);
            }
            if (command.equals("LOGOUT")) {
                break;
            } else if (command.equals("!STOP") && response.equals("OK")) {
                break;
            }
        }
    }

    public static void main(String[] args) throws IOException {

        Socket socket = null;
        try {
            Scanner in = new Scanner(System.in);
            System.out.println("ENTER IP: ");
            String serverAddress = in.next();
            System.out.println("ENTER PORT: ");
            int port = in.nextInt();

            socket = new Socket(serverAddress, port);
            BufferedReader rd = new BufferedReader(new InputStreamReader(socket.getInputStream()));
            BufferedWriter wr = new BufferedWriter(new OutputStreamWriter(socket.getOutputStream()));

            sendCommand("CHECK", wr);
            System.out.println(rd.readLine());

            start(rd, wr, in);
        } catch (Exception e) {
            System.out.println("Error:" + e.getMessage());
        } finally {
            try {
                socket.close();
            } catch (Exception e) {
                System.out.println("Error:" + e.getMessage());
            }
        }
    }
}
