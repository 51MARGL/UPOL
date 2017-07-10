/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package kudryashov.zp3jv.s02;

/**
 *<h1>Point class</h1>
 * Point class represents point
 * that inludes x and y coordinates
 * @author Serhiy Kudryashov
 * @version 1.1 11/11/2016
 */
public class Point implements Distance {
    
    /**
     * x coordinate of point 
     */
    public double x;
    
    /**
     * y coordinate of point 
     */
    public double y;
    
    /**
     * Creats new point in given coordinates
     * @param x x coordinate of point 
     * @param y y coordinate of point 
     */
    public Point(double x, double y){
        super();
        this.x = x;
        this.y = y;
    }
    
    /**
     * Implementation of distance interface
     * @param p point
     * @return distance between point and given point
     */    
    @Override
    public double distance(Point p){
        return Math.sqrt(Math.pow((this.x - p.x), 2) 
                + Math.pow((this.y - p.y), 2));
    }
}
