/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package cv.pkg9;

import javafx.beans.property.IntegerProperty;
import javafx.beans.property.SimpleIntegerProperty;

/**
 *
 * @author 97pib
 */
public class Ship {

    IntegerProperty x;
    IntegerProperty y;

    public Ship(int x, int y) {
        this.x = new SimpleIntegerProperty(x);
        this.y = new SimpleIntegerProperty(y);
    }

    public int getX() {
        return x.intValue();
    }

    public void setX(int x) {
        this.x.setValue(x);
    }

    public IntegerProperty getYIntegerProperty() {
        return y;
    }

    public int getY() {
        return y.intValue();
    }
    
    public void setY(int y) {
        this.y.setValue(y);
    }

    public IntegerProperty getXIntegerProperty() {
        return x;
    }

}
