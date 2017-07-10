/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package kudryashov.zp3jv.s03;

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
}
