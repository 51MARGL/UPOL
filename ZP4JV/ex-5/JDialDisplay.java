/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package cv.pkg5;

import java.awt.Color;
import java.awt.Graphics;
import java.awt.Graphics2D;
import java.awt.RenderingHints;
import javax.swing.JComponent;

/**
 *
 * @author 97pib
 */
public class JDialDisplay extends JComponent {

    private String displayTxt = "";

    public JDialDisplay() {

    }

    private int getTextSizeX() {
        return getBounds().x + (getBounds().width / 2) - (displayTxt.length() * 6);
    }

    private int getTextSizeY() {
        return getBounds().y + (getBounds().height / 2) + 5;
    }

    public void print(String s) {
        displayTxt = s;
        repaint();
    }

    public void concat(String s) {
        if (displayTxt.length() > 15) {
            displayTxt = "..." + s;
        } else {
            displayTxt += s;
        }
        repaint();
    }

    public String getText() {
        return displayTxt;
    }

    public int getIntValue() {
        return Integer.parseInt(displayTxt);
    }

    @Override
    public void paintComponent(Graphics g) {
        Graphics2D g2 = (Graphics2D) g;
        g2.setRenderingHint(RenderingHints.KEY_ANTIALIASING, RenderingHints.VALUE_ANTIALIAS_ON);
        g2.setColor(Color.DARK_GRAY);
        g2.fillRect(getBounds().x, getBounds().y, getBounds().width, getBounds().height);
        g2.setColor(Color.LIGHT_GRAY);
        g2.setFont(g2.getFont().deriveFont(25f));
        g2.drawString(displayTxt, getTextSizeX(), getTextSizeY());
    }
}
