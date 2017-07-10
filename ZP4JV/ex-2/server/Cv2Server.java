/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package cv2.server;

import java.io.IOException;
import java.net.ServerSocket;
import java.net.Socket;
import java.util.ArrayList;

/**
 *
 * @author Kudryashov
 */
public class Cv2Server {

    public static boolean stopServer = false;
    private static ArrayList<User> connectedUsers;
    private static ArrayList<Thread> threads;

    public static synchronized void addUser(User u) {
        connectedUsers.add(u);
    }

    public static synchronized ArrayList<User> getUsers() {
        return connectedUsers;
    }

    public static synchronized void stopThreads() {
        for (Thread thread : threads) {
            thread.interrupt();
        }
    }

    public static void main(String[] args) throws IOException {
        try (ServerSocket srvSocket = new ServerSocket(4242)) {
            connectedUsers = new ArrayList<>();
            threads = new ArrayList<Thread>();
            while (true) {
                System.out.println("Waiting for a client");
                Socket clientSocket = srvSocket.accept();
                if (stopServer) {
                    break;
                }
                Thread serverThread = new ServerThread(clientSocket);
                threads.add(serverThread);
                serverThread.start();
            }
            System.out.println("Server Closed!");
        } catch (Exception e) {
            System.out.println("Error:" + e.getMessage());
        }
    }
}
