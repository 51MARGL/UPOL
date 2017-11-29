/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package kudryashov.zp3jv.s06;

import java.util.ArrayList;
import java.util.EmptyStackException;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.Stack;

/**
 *
 * @author 97pib
 */
public class j6 {

    /**
     * @param args the command line arguments
     */
    public static Map<String, Integer> freq(String s) {
        Map<String, Integer> m = new HashMap<String, Integer>();
        String[] help = s.replaceAll("[^A-Za-z]", " ")
                .split("\\s+");        
        for (String a : help) {
            Integer freq = m.get(a);
            m.put(a, (freq == null) ? 1 : freq + 1);
        }
        System.out.println(m.size() + " distinct words:");
        System.out.println(m);
        return m;
    }
    
    public static Map<String, Integer> freqIgnoreCase(String s) {
        return freq(s.toLowerCase());
    }
    
    public static void rpnCalc(String expr, Map <String, Integer> variables) 
            throws EmptyStackException { 
        Stack<Double> stack = new Stack<>();
        System.out.println(expr);
        for (String token : expr.split("\\s+")) {
            switch (token) {
                case "+":
                    stack.push(stack.pop() + stack.pop());
                    break;
                case "-":
                    stack.push(-stack.pop() + stack.pop());
                    break;
                case "*":
                    stack.push(stack.pop() * stack.pop());
                    break;
                case "/":
                    double divisor = stack.pop();
                    stack.push(stack.pop() / divisor);
                    break;
                default:
                    if (variables.containsKey(token)) {
                        stack.push(Double.parseDouble(variables.get(token)
                                .toString()));
                    } else {
                        try {
                            stack.push(Double.parseDouble(token));
                        } catch (IllegalArgumentException e) {
                            System.out.println("Wrong arg:" 
                                    + e.getMessage());
                        }
                    }
                    break;
            }
        }
        System.out.println("Final Answer: " + stack.pop());
    }

    public static void main(String[] args) {
        System.out.println("Task 1:");
        Set<Point> listPt = new HashSet<>();
        Point p1 = new Point(5,5);
        Point p2 = new Point(10,5);
        Point p3 = new Point(5,10);
        Point p4 = new Point(5,5);
        Point p5 = new Point(5,10);
        listPt.add(p1);
        listPt.add(p2);
        listPt.add(p3);
        listPt.add(p4);
        listPt.add(p5);
        for (Point x : listPt) {
            System.out.println("x = " + x.x + " y = " + x.y);
        }
        
        System.out.println("\nTask 2:");
        freq("ahoJ,-12 lol / ahoj - lol");
        
        System.out.println("\nTask 3:");
        freqIgnoreCase("ahoJ,-12 lol* ahoj- lol"); 
        
        System.out.println("\nTask 4+5:");
        Map<String, Integer> f = new HashMap<>();
        f.put("foo", 10);
        try {
            rpnCalc("1 32 + 42 * 5 + 66 - foo +", f);
        } catch (Exception err) {
            System.out.println(err.getMessage());
        }
    }
}
