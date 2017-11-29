/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package kudryashov.zp3jv.s02;

/**
 *<h1>Rectangle class</h1>
 * Rectangle class represents rectangle
 * that inludes 4 vertices and lines between 
 * @author Serhiy Kudryashov
 * @version 1.1 11/11/2016
 */
public class Rectangle extends Line implements Distance{
    
    /**
     * 4 vertices of rectangle
     */
    private Point a, b, c, d;
    
    /**
     * 4 lines of rectangle
     */
    private Line ab, bc, cd, da;
    
    /**
     * Creats new rectangle from 2 vertices
     * @param p1 first vertice
     * @param p2 second vertice 
     */
    public Rectangle(Point p1, Point p2) {
        super(p1, p2);
        a = new Point(p1.x, p1.y);
        c = new Point(p2.x, p2.y);
        b = new Point(p1.x, p1.y);
        d = new Point(p2.x, p2.y);
        b.x = a.x;
        b.y = c.y;
        d.x = c.x;
        d.y = a.y;
        ab = new Line(a, b);
        bc = new Line(b, c);
        cd = new Line(c, d);
        da = new Line(d, a);
    }
    
    /**
     * Creats new rectangle from 1 vertice, weidth and height
     * @param p vertice
     * @param syr weidth 
     * @param vys height
     */
    public Rectangle(Point p, double syr, double vys){
        super(p, p);
        a = new Point(p.x, p.y);
        b = new Point(p.x, p.y);
        c = new Point(p.x, p.y);
        d = new Point(p.x, p.y);
        b.x = a.x;
        b.y = a.y + vys;
        c.x = b.x + syr;
        c.y = b.y;
        d.x = c.x;
        d.y = a.y;
        ab = new Line(a, b);
        bc = new Line(b, c);
        cd = new Line(c, d);
        da = new Line(d, a);
    }
    
    /**
     * Calculates the area of rectangle
     * @return area of rectangle
     */
    public double getArea(){
        return (ab.getLength() * bc.getLength());
    }
    
    /**
     * Implementation of distance interface
     * @param p point
     * @return distance between rectangle and given point
     */
    @Override
    public double distance(Point p){
        return Math.min(Math.min(ab.distance(p), bc.distance(p)), 
                Math.min(cd.distance(p), da.distance(p)));
    }
}
