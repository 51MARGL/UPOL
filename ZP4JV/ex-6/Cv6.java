/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package cv.pkg6;

import javax.swing.JFrame;
import javax.swing.JOptionPane;

/**
 *
 * @author 97pib
 */
public class Cv6 {

    /**
     * @param args the command line arguments
     */
    public static void main(String[] args) {
        try {
            MainForm form = new MainForm();
            form.setVisible(true);
        } catch (Exception e) {
            JOptionPane.showMessageDialog(new JFrame(),
                    e.getLocalizedMessage(),
                    "Warning",
                    JOptionPane.WARNING_MESSAGE);
        }
    }
    
}
