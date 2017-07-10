/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package kudryashov.zp3jv.s02;

/**
 *<h1>Circle class</h1>
 * Circle class represents simple circle
 * with given center and radius
 * @author Serhiy Kudryashov
 * @version 1.1 11/11/2016
 */
public class Circle extends Point implements Distance{
    
    /**
     * Center of circle 
     */
    private Point c;
    
    /**
     * Radius of circle 
     */
    private double r;
    
    /**
     * Creats new circle with given center and radius
     * @param c center of circle
     * @param r radius of circle
     */
    public Circle(Point c, double r){
        super(c.x, c.y);
        this.c = c;
        this.r = r;
    }
    
    /**
     * Calculates the area of circle
     * @return area of circle
     */
    public double getArea(){
        return Math.PI * r * r;
    }
    
    /**
     * Implementation of distance interface
     * @param p point
     * @return distance between circle and given point
     */
    @Override
    public double distance(Point p){
        return Math.abs(p.distance(c) - r);
    }
}
