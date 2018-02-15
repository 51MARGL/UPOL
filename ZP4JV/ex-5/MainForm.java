/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package cv.pkg5;

import java.awt.BorderLayout;
import java.awt.Color;
import java.awt.Dimension;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import javax.swing.JDialog;
import javax.swing.JFrame;
import javax.swing.JOptionPane;
import javax.swing.JPanel;

/**
 *
 * @author 97pib
 */
public class MainForm extends JFrame{
    
    public MainForm(){
        super();
        
        setDefaultCloseOperation(EXIT_ON_CLOSE);
        setPreferredSize(new Dimension(315, 540));
        setMinimumSize(new Dimension(315,540));
        setBackground(Color.BLACK);
        JDialPad pad = new JDialPad();
        setContentPane(pad);
        
        
       
        addTest(pad);
        addTest2(pad);
        pack();
    }

    private void addTest(JDialPad pad) {
        pad.addActionListener(new ActionListener() {
            @Override
            public void actionPerformed(ActionEvent e) {
                JOptionPane.showMessageDialog(new JFrame(),
                    "!!!Enter pressed-TEST 1 !!!",
                    "Hoora",
                    JOptionPane.WARNING_MESSAGE);
            }
        });
    }

    private void addTest2(JDialPad pad) {
        pad.addActionListener(new ActionListener() {
            @Override
            public void actionPerformed(ActionEvent e) {
                JOptionPane.showMessageDialog(new JFrame(),
                    "???Enter pressed-TEST 2 ???\n Value on Screen: " + pad.display.getText(),
                    "Hoora",
                    JOptionPane.WARNING_MESSAGE);
            }
        });
    }
}
