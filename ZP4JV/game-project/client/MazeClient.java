/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package maze.client;

/**
 * <h1>Maze Client</h1>
 * The Maze Client program implements an application that
 * represents Client for maze game
 * @author Serhiy Kudryashov
 * @version 1.0 25/11/2016
 */

import java.awt.BorderLayout;
import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.PrintWriter;
import java.net.ConnectException;
import java.net.Socket;
import java.net.SocketException;
import javax.swing.JFrame;
import javax.swing.JLabel;
import javax.swing.JOptionPane;


public class MazeClient extends JFrame {

    private JFrame frame = new JFrame("Maze");
    private JLabel messageLabel = new JLabel("");
    private JLabel scoreLabel = new JLabel("");
    private final int OFFSET = 50;
    private static int PORT = 8901;
    private Socket socket;
    private BufferedReader in;
    private PrintWriter out;
    private Board board;
    private int yourScore = 0;
    private int opponentScore = 0;

    public MazeClient() throws IOException {
        // Setup networking
        String serverAddress = askForIP ();
        try {
            socket = new Socket(serverAddress, PORT);
            in = new BufferedReader(new InputStreamReader(
                    socket.getInputStream()));
            out = new PrintWriter(socket.getOutputStream(), true);
        } catch (ConnectException e) {
            JOptionPane.showMessageDialog(frame,
            "Can't connect to server\n"
                    + e.getMessage(),
            "Connection error",
            JOptionPane.ERROR_MESSAGE);
            System.exit(0);
        }
        InitUI();
    }

    public void serverError(SocketException e) {
        JOptionPane.showMessageDialog(frame,
            "Server down\n"
                    + e.getMessage(),
            "Connection error",
            JOptionPane.ERROR_MESSAGE);
            System.exit(0);
    }
    
    public void InitUI() {
        board = new Board(out);
        add(board);
        scoreLabel.setText("Your moves: " 
                + yourScore 
                + "   Opponent moves: " 
                + opponentScore);
        add(messageLabel, BorderLayout.AFTER_LAST_LINE);
        add(scoreLabel, BorderLayout.BEFORE_FIRST_LINE);
        setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
        setSize(board.getBoardWidth() + OFFSET - 35,
                board.getBoardHeight() + OFFSET);
        setLocationRelativeTo(null);
        setTitle("Maze");
        setResizable(false);
    }
    
    public String askForIP (){
        String s = null;
        try {
            s = (String)JOptionPane.showInputDialog(
                frame,
                "Enter Server Address:\n",
                "Welcome",
                JOptionPane.PLAIN_MESSAGE);
            if (s.isEmpty()) System.exit(0);
        } catch (Exception e){
            System.exit(0);
        }
        return s;
    }
    
    public void play() throws Exception {
        String response;
        yourScore = 0;
        opponentScore = 0;
        try {
            response = in.readLine();
            if (response.startsWith("WELCOME")) {
                char mark = response.charAt(8);
                board.you = mark == '1' ? board.player1 : board.player2;
                board.opponent = mark == '1' ? board.player2 : board.player1;
                messageLabel.setText("Maze - Player " + mark);
            }
            while (true) {
                response = in.readLine();
                if (response.startsWith("VALID_MOVE")) {
                    messageLabel.setText("Valid move, please wait");
                    board.youCanMove = false;
                    yourScore++;
                    scoreLabel.setText("Your moves: " 
                            + yourScore 
                            + "   Opponent moves: " 
                            + opponentScore);
                } else if (response.startsWith("OPPONENT_MOVED")) {
                    int loc = Integer.parseInt(response.substring(15));
                    board.moveOpponent(loc);
                    messageLabel.setText("Opponent moved, your turn");
                    board.youCanMove = true;
                    opponentScore++;
                    scoreLabel.setText("Your moves: " 
                            + yourScore 
                            + "   Opponent moves: " 
                            + opponentScore);
                } else if (response.startsWith("VICTORY")) {
                    messageLabel.setText("You are winner");
                    break;
                } else if (response.startsWith("DEFEAT")) {
                    messageLabel.setText("You are loser");
                    break;
                } else if (response.startsWith("DISCONNECT")) {
                    messageLabel.setText("!Opponent left the game!");
                    break; 
                } else if (response.startsWith("MESSAGE")) {
                    messageLabel.setText(response.substring(8));
                        if (response.contains("Your move")) {
                            board.youCanMove = true;
                        }
                }
            }
            out.println("QUIT");
        }
        finally {
            socket.close();
        }
    }
    
    private boolean wantsToPlayAgain() {
        int response = JOptionPane.showConfirmDialog(frame,
            "Want to play again?",
            "Game Over",
            JOptionPane.YES_NO_OPTION);
        dispose();
        board.restartLevel();
        return response == JOptionPane.YES_OPTION;
    }

    /**
     * @param args the command line arguments
     */

    public static void main(String[] args) throws Exception {
        while (true) {
            MazeClient client = new MazeClient();
            client.setVisible(true);
            try {
                client.play();
            } catch (SocketException e) {
                client.serverError(e);
            }
            if (!client.wantsToPlayAgain()) {
                break;
            }
        }
    }
}

