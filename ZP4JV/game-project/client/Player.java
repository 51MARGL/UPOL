/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package maze.client;

import java.awt.Image;
import javax.swing.ImageIcon;

public class Player extends Actor {

    private ImageIcon iia;
    private Image image;
    public Player(int x, int y, char i) {
        super(x, y);
        switch (i){
            case '1':
                iia = new ImageIcon(this.getClass()
                        .getClassLoader().getResource("player1.gif"));
                image = iia.getImage();
                this.setImage(image);
                break;
            case '2':
                iia = new ImageIcon(this.getClass()
                        .getClassLoader().getResource("player2.gif"));
                image = iia.getImage();
                this.setImage(image);
                break;
        }
    }

    public void move(int x, int y) {
        int nx = this.x() + x;
        int ny = this.y() + y;
        this.setX(nx);
        this.setY(ny);
    }
}
