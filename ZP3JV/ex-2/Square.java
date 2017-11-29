/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package kudryashov.zp3jv.s02;

/**
 *<h1>Square class</h1>
 * Square class represents square
 * @author Serhiy Kudryashov
 * @version 1.1 11/11/2016
 */
public class Square extends Rectangle{
    
    /**
     * Creats new square from 1 vertice and height
     * @param p vertice
     * @param del height
     */
    public Square(Point p, double del) {
        super(p, del, del);
    }
}
