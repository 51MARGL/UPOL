/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package kudryashov.zp3jv.s02;

/**
 *<h1>Line class</h1>
 * Line class represents line
 * that inludes 2 points
 * @author Serhiy Kudryashov
 * @version 1.1 11/11/2016
 */
public class Line extends Point implements Distance{
     
    /**
     * First point of line
     */
    private Point start;
    
    /**
     * Second point of line
     */
    private Point end;
    
    /**
     * Creats new line form given points
     * @param p1 first point
     * @param p2 second point
     */
    public Line(Point p1, Point p2) {
        super(p1.x, p1.y);
        this.start = new Point(p1.x, p1.y);
        this.end = new Point(p2.x, p2.y);
    }
    
    /**
     * Calculates length of line
     * @return line's length
     */
    public double getLength(){
        return start.distance(end);
    }
    
    /**
     * Implementation of distance interface
     * @param p point
     * @return distance between line and given point
     */
    @Override
    public double distance(Point p){
        double px = end.x - start.x;
        double py = end.y - start.y;
        double temp = (px * px) + (py * py);
        double u = ((p.x - start.x) * px + (p.y - start.y) * py) / (temp);
        if (u > 1){
            u = 1;
        }else if (u < 0){
            u = 0;
        }
        double x = start.x + u * px;
        double y = start.y + u * py;

        double dx = x - p.x;
        double dy = y - p.y;
        return Math.sqrt(dx * dx + dy * dy);
    }
}
