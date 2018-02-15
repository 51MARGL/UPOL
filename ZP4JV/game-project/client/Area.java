/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package maze.client;

import java.awt.Image;
import javax.swing.ImageIcon;

public class Area extends Actor {

    public Area(int x, int y) {
        super(x, y);
        ImageIcon iia = new ImageIcon(this.getClass()
                .getClassLoader().getResource("area.gif"));
        Image image = iia.getImage();
        this.setImage(image);
    }
}
