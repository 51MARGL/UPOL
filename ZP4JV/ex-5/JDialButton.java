/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package cv.pkg5;

import java.awt.Graphics;
import java.awt.Graphics2D;
import java.awt.RenderingHints;
import javax.swing.Action;
import javax.swing.JComponent;
import java.awt.Color;
import java.awt.event.ActionEvent;

/**
 *
 * @author 97pib
 */
public class JDialButton extends JComponent {

    private String buttonTxt = "";
    private Action action;

    public JDialButton() {

    }

    public JDialButton(String buttonTxt) {
        this.buttonTxt = buttonTxt;
    }

    public void setButtonTxt(String txt) {
        buttonTxt = txt;
    }

    public String getButonTxt() {
        return buttonTxt;
    }

    public void setAction(Action action) {
        this.action = action;
    }
    
    public void actionPerformed(ActionEvent e){
        if (action != null) {
            action.actionPerformed(e);
        }
    }

    private int getTextSizeX() {
        return (getBounds().width / 2) - (buttonTxt.length() * 3);
    }

    private int getTextSizeY() {
        return (getBounds().height / 2) + 5;
    }

    @Override
    public void paintComponent(Graphics g) {
        Graphics2D g2 = (Graphics2D) g;
        g2.setRenderingHint(RenderingHints.KEY_ANTIALIASING, RenderingHints.VALUE_ANTIALIAS_ON);

        g2.setColor(Color.cyan);
        g2.fillRect(0, 0, getBounds().width - 1, getBounds().height - 1);

        g2.setColor(Color.BLACK);
        g.setFont(g.getFont().deriveFont(25f));
        g2.drawString(buttonTxt, getTextSizeX(), getTextSizeY());
    }
}
