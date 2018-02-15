/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package maze.server;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.PrintWriter;
import java.net.Socket;

/**
 *
 * @author 97pib
 */
public class Game {
    Player currentPlayer;

    public synchronized boolean legalMove(int location, Player player) {
        if (player == currentPlayer) {
            currentPlayer = currentPlayer.opponent;
            currentPlayer.otherPlayerMoved(location);
            return true;
        }
        return false;
    }

    class Player extends Thread {
        char mark;
        Player opponent;
        Socket socket;
        BufferedReader input;
        PrintWriter output;


        public Player(Socket socket, char mark) {
            this.socket = socket;
            this.mark = mark;
            try {
                input = new BufferedReader(
                    new InputStreamReader(socket.getInputStream()));
                output = new PrintWriter(socket.getOutputStream(), true);
                output.println("WELCOME " + mark);
                output.println("MESSAGE Waiting for opponent to connect");
            } catch (IOException e) {
                System.out.println("Player died: " + e);
            }
        }

        public void setOpponent(Player opponent) {
            this.opponent = opponent;
        }

        public void otherPlayerMoved(int location) {
            output.println("OPPONENT_MOVED " + location);
        }

        @Override
        public void run() {
            try {
                output.println("MESSAGE All players connected");

                if (mark == '1') {
                    output.println("MESSAGE Your move");
                }
                while (true) {
                    String command = input.readLine();
                    if (command.startsWith("MOVE")) {
                        int location = Integer.parseInt(command.substring(5));
                        if (legalMove(location, this)) {
                            output.println("VALID_MOVE");
                        } else {
                            output.println("MESSAGE ?");
                        }
                    }else if (command.startsWith("WINNER")) {
                        output.println("VICTORY");
                        opponent.output.println("DEFEAT");
                        break;
                    }else if (command.startsWith("QUIT")) {
                        return;
                    }
                }
            } catch (IOException e) {
                System.out.println("Player died: " + e);
                opponent.output.println("DISCONNECT");
            } finally {
                try {
                    socket.close();
                } catch (IOException e) {}
            }
        }
    }
}
