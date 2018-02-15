/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package kudryashov.zp3jv.s02;

/**
 * <h1>2. Task of ZP3JV</h1>
 * The j2 program implements an application that
 * works with geometric figures
 * @author Serhiy Kudryashov
 * @version 1.1 11/11/2016
 */
public class j2 {

    /**
     * This is the main method which make tests of
     * figures's classes and methods
     * @param args the command line arguments
     */
    public static void main(String[] args) {
        //task1
        Point begin = new Point(2, -5);
        Point dot = new Point(-4, 3);
        System.out.println("Distance between dots = " + begin.distance(dot));
        
        
        //task2
        Point start = new Point(-4, 0);
        Point end = new Point(-4, 10);
        Line l1 = new Line(start, end);
        System.out.println("\nLine length = " + l1.getLength());
        System.out.println("Distance between dot and line = " 
                + l1.distance(dot));
        
        
        //task3
        Point a = new Point(1, 5);
        Point c = new Point(6, 3);
        Rectangle rc1 = new Rectangle(a, c);
        System.out.println("\nArea of first = " + rc1.getArea());
        Rectangle rc2 = new Rectangle(dot, 4, 2);
        System.out.println("Area of second = " + rc2.getArea());
        Point dot2 = new Point(5, 5);
        System.out.println("Dist to first = " + rc1.distance(dot2));
        System.out.println("Dist to second = " + rc2.distance(dot2));
        
        
        //task4
        Point dot3 = new Point(0, 0);
        Square sq = new Square(dot3, 5);
        System.out.println("\nSq area = " + sq.getArea());
        System.out.println("Dis to sq = " + sq.distance(dot2));
        
        
        //task5
        Point cn = new Point(-5, -5);
        Circle cr = new Circle(cn, 5);
        Point dot4 = new Point(-5, 1);
        System.out.println("\nArea of circle = " + cr.getArea());
        System.out.println("Dis to circle = " + cr.distance(dot4));  
    }
}
