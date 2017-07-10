/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package kudryashov.zp3jv.s06;

import java.util.Objects;

/**
 *
 * @author 97pib
 */
public class Point {
    public double x;
    public double y;
 
    public Point(double x, double y){
        super();
        this.x = x;
        this.y = y;
    }
        
    public double distance(Point p){
        return Math.sqrt(Math.pow((this.x - p.x), 2) 
                + Math.pow((this.y - p.y), 2));
    }
    
   
    @Override
    public boolean equals(Object o) {

        if (o == this) return true;
        if (!(o instanceof Point)) {
            return false;
        }
        Point pt = (Point) o;
        return x == pt.x && y == pt.y;
    }
    
    @Override
    public int hashCode() {
        return Objects.hash(x, y);
    }

}
