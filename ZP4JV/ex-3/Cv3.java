/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package cv.pkg3;

import javax.swing.JFrame;

/**
 *
 * @author 97pib
 */
public class Cv3 {

    /**
     * @param args the command line arguments
     */
    public static void main(String[] args) {
        try {
            JFrame form = new Savings();
            form.setVisible(true);
        }catch (Exception e) {
            System.out.println("Error: " + e.getLocalizedMessage());
        }
    }

}
