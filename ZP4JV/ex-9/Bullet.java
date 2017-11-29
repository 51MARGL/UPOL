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
import javafx.scene.image.ImageView;
import javafx.scene.layout.Pane;
import javafx.scene.paint.Color;
import javafx.scene.shape.Rectangle;
import javafx.util.Duration;

public class Bullet {

    public boolean bulletIsAlive = true;
    Rectangle r = null;
    Pane p;
    int incr;
    static Rectangle rect = Cv9.pointer;

    public Bullet(double x, double y, double pos, ImageView v[], Pane p) {
        if (r == null) {
            this.p = p;
            Timeline tlB;
            r = new Rectangle(x, y);
            r.setFill(Color.ORANGERED);

            InnerShadow is = new InnerShadow();
            is.setOffsetY(1.0);
            is.setOffsetX(1.0);
            is.setColor(Color.YELLOW);
            r.setEffect(is);
            
            p.getChildren().add(r);
            r.setX(pos + 35);
            r.setY(640);
            Duration dB = new Duration(5);
            KeyFrame fB = new KeyFrame(dB, e -> {
                if (r != null) {
                    r.setY(r.getY() - 5);
                    collisioncheck(v);
                }
            });
            tlB = new Timeline(fB);
            tlB.setCycleCount(Animation.INDEFINITE);
            tlB.play();
        }
    }

    private boolean collisioncheck(ImageView enemies[]) {
        for (int i = 0; i < enemies.length; i++) {
            if (r != null && enemies[i] != null) {
                if ((r != null && r.getX() < enemies[i].getX() + enemies[i].getFitWidth()
                        && r.getX() + r.getWidth() > enemies[i].getX()
                        && r.getY() < enemies[i].getY() + enemies[i].getFitHeight()
                        && r.getHeight() + r.getY() > enemies[i].getY())) {
                    enemies[i].setVisible(false);
                    enemies[i] = null;
                    Cv9.enemiesCount--;
                    removeBullet();
                    bulletIsAlive = false;
                    incr += 50;
                }
            }
        }
        if (r != null) {
            if (r.getY() < 0 - r.getHeight() - 1) {
                bulletIsAlive = false;
                removeBullet();
            }
        }
        return bulletIsAlive;
    }

    public int getScore() {
        int x = incr;
        incr = 0;
        return x;
    }

    public void getRectangle(Rectangle rect) {
        this.rect = rect;
    }

    public void removeBullet() {
        p.getChildren().remove(r);
        r = null;
    }
}
