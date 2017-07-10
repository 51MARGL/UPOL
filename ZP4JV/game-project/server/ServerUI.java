/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package maze.server;

import java.io.PrintWriter;
import javax.swing.JFrame;
import javax.swing.JLabel;

/**
 *
 * @author 97pib
 */
public class ServerUI extends JFrame {
    PrintWriter output;
    private JLabel messageLabel = new JLabel("");
        
    public ServerUI() {
        messageLabel.setText("Server is running");
        add(messageLabel);
        setSize(250, 100);
        setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
        setTitle("Server");
        setVisible(true);
    }
}
