/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package cv.pkg9;

import javafx.animation.Animation;
import javafx.animation.KeyFrame;
import javafx.animation.Timeline;
import javafx.scene.effect.InnerShadow;
import javafx.scene.layout.Pane;
import javafx.scene.paint.Color;
import javafx.scene.shape.Rectangle;
import javafx.util.Duration;

/**
 *
 * @author 97pib
 */
public class EnemyBullet {

    public boolean bulletIsAlive = true;
    Rectangle r = null;
    Pane p;

    public EnemyBullet(double x, double y, double posX, double posY, Ship ship, Pane p) {
        if (r == null) {
            this.p = p;
            Timeline tlB;
            r = new Rectangle(x, y);
            r.setFill(Color.ORANGERED);

            InnerShadow is = new InnerShadow();
            is.setOffsetY(1.0);
            is.setOffsetX(1.0);
            is.setColor(Color.RED);
            r.setEffect(is);

            p.getChildren().add(r);
            r.setX(posX + 15);
            r.setY(posY + 10);
            Duration dB = new Duration(5);
            KeyFrame fB = new KeyFrame(dB, e -> {
                if (r != null) {
                    r.setY(r.getY() + 3);
                    collisioncheck(ship);
                }
            });
            tlB = new Timeline(fB);
            tlB.setCycleCount(Animation.INDEFINITE);
            tlB.play();
        }
    }

    private boolean collisioncheck(Ship ship) {
        if (r.getX() >= ship.getX() - 15 && r.getX() <= ship.getX() + 25 && r.getY() >= ship.getY() - 10) {
            bulletIsAlive = false;
            removeBullet();
            Cv9.gameover = true;
        }
        if (r != null) {
            if (r.getY() >= ship.getY() + 20) {
                bulletIsAlive = false;
                removeBullet();
            }
        }
        return bulletIsAlive;
    }

    public void removeBullet() {
        p.getChildren().remove(r);
        r = null;
    }
}
