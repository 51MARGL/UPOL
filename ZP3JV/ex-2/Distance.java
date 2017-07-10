/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package kudryashov.zp3jv.s02;

/**
 *<h1>Distance interface</h1>
 * Calculating distance between objects
 * @author Serhiy Kudryashov
 * @version 1.1 11/11/2016
 */
public interface Distance {
    
    /**
     * Implementation of distance interface
     * @param p point
     * @return distance between object and given point
     */
    public double distance(Point p);
}
