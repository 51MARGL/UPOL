/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package maze.server;

/**
 * <h1>Maze Server</h1>
 * The Maze Server program implements an application that
 * represents server for maze game
 * @author Serhiy Kudryashov
 * @version 1.0 25/11/2016
 */

import java.io.IOException;
import java.net.ServerSocket;

public class MazeServer {
  
    /**
     * @param args the command line arguments
     */
    
    public static void main(String[] args) throws IOException {
        ServerSocket listener = new ServerSocket(8901);
        System.out.println("Server is Running");
        ServerUI ui = new ServerUI();
        try {
            while (true) {
                Game game = new Game();
                Game.Player player1 = game.new Player(listener.accept(), '1');
                Game.Player player2 = game.new Player(listener.accept(), '2');
                player1.setOpponent(player2);
                player2.setOpponent(player1);
                game.currentPlayer = player1;
                player1.start();
                player2.start();
            }
        } finally {
            listener.close();
            ui.dispose();
        }
    }
}

