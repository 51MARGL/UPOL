/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package kudryashov.zp3jv.s08;

import java.util.EmptyStackException;
import java.util.Map;
import java.util.Stack;

/**
 *<h1>Calculator class</h1>
 * Calculator class represents RPNcalculator
 * that takes expression from text
 * @author Serhiy Kudryashov
 * @version 1.0 12/11/2016
 */
public class Calculator {
    
    /**
     * Stack of values from text line
     * also keeps final answer
     */
    private Stack<String> stack = new Stack<>();
    
    /**
     * Compares 2 values in stack
     * @return 1 - first is larger
     *         2 - second is larger
     *         0 - equals
     * @throws Exception if can't compare 2 values
     */
    private int comparing() throws Exception {
        Double x;
        int t = 0;
        String s1 = stack.pop();
        String s2 = stack.pop();
        try {
            x = Double.parseDouble(s1);
            t = x.compareTo(Double.parseDouble(s2));
        } catch (Exception e) {
            try {
                if (s1.equals("#t") 
                        && s2.equals("#f")) {
                    t = 1;
                } else if (s1.equals("#f") 
                        && s2.equals("#t")) {
                    t = -1;
                } else if (s1.equals("#t") 
                        && s2.equals("#t")) {
                    t = 0;
                } else throw e;
            } catch (Exception e1) {
                System.out.println("Comparing error");
                throw e1;
            }
        }
        return t;
    }
    
    /**
     * Gets result from stack
     * and tests it
     * @throws Exception if result is corrupted 
     */
    private void getResult() throws Exception {
        try {
            Double x = Double.parseDouble(stack.peek());
            if (x == x.intValue()) {
                System.out.println("Final Answer: " + x.intValue());   
            } else {
                System.out.println("Final Answer: " + x);
            }
        } catch (Exception e) {
            try {
                System.out.println("Final Answer: " + stack.pop());    
            } catch (Exception e1) {
                System.out.println("Result error");
                throw e;
            }
        }
    }
    
    /**
     * Adds values to stack 
     * @param token - value to add
     * @param variables list of Map values
     * @throws IllegalArgumentException when 
     * adds unknown expression
     */
    private void add(String token, Map <String, Integer> ... variables) 
            throws IllegalArgumentException {
        Double x;
        if(variables.length > 0){
            if (variables[0].containsKey(token)) {
                x = Double
                        .parseDouble(variables[0].get(token)
                                .toString());
                stack.push(x.toString());
                return;
            }   
        } 
        try {
            stack.push(token);
        } catch (IllegalArgumentException e) {
            System.out.println("Wrong arg:" 
                    + e.getMessage());
        }
    }
    
    /**
     * Ternary operator implementation
     * @param s value on top of the stack 
     * @throws Exception if gets not-bool expression
     * from stack
     */
    private void terOp(String s) throws Exception{
        try {
            switch (s) {
                case "#t":
                    stack.push(stack.pop());
                    break;
                case "#f":
                    stack.pop();
                    stack.push(stack.pop());
                    break;
                default:
                    throw new Exception("Exception - "
                            + s + " isn't bool");
            }
        } catch (Exception e) {
            throw e;
        }
    }

    /**
     * Calls calculator with given text expression 
     * and list of map variables (!USE ONLY 1 OR 0!)
     * Calls result
     * Clears stack after calculating
     * @param expr full text line to calculate
     * @param variables list of map variables
     */
    public void rpnCalc(String expr, Map <String, Integer> ... variables) {
        try {
            rpnCalculator(expr, variables);
            getResult();
        } catch (Exception err) {
            System.out.println(err.getMessage());
        } finally {
            stack.clear();
        }
    }
    
    /**
     * RPNcalculator works with given text expression 
     * and list of map variables (!USE ONLY 1 OR 0!)
     * @param expr full text line to calculate
     * @param variables list of map variables
     * @throws EmptyStackException if stack isEmpty
     * @throws ArithmeticException if divided by 0
     * @throws Exception if defined methods throws Exception
     */
    public void rpnCalculator(String expr, 
            Map <String, Integer> ... variables) 
            throws EmptyStackException,
            ArithmeticException, 
            Exception{ 
        
        Double x;
        System.out.println(expr);
        for (String token : expr.split("\\s+")) {
            switch (token) {
                case "+":
                    x = Double.parseDouble(stack.pop()) 
                            + Double.parseDouble(stack.pop());
                    stack.push(x.toString());
                    break;
                case "-":
                    x = -Double.parseDouble(stack.pop()) 
                            + Double.parseDouble(stack.pop());
                    stack.push(x.toString());
                    break;
                case "*":
                    x = Double.parseDouble(stack.pop()) 
                            * Double.parseDouble(stack.pop());
                    stack.push(x.toString());
                    break;
                case "/":
                    double divisor = Double.parseDouble(stack.pop());
                    if (divisor == 0) {
                        throw new ArithmeticException("Can't divide by 0");
                    } else {
                        x = Double.parseDouble(stack.pop()) 
                            / divisor;
                        stack.push(x.toString());
                    }  
                    break;
                case "=":
                    if (comparing() == 0){
                        stack.push("#t");
                    } else {
                        stack.push("#f");
                    }
                    break;
                case ">":
                    if (comparing() < 0) {
                        stack.push("#t");
                    } else {
                        stack.push("#f");
                    }
                    break;
                case "<":
                    if (comparing() > 0) {
                        stack.push("#t");
                    } else {
                        stack.push("#f");
                    }
                    break;
                case "!=":
                    if (!(comparing() == 0)) {
                        stack.push("#t");
                    } else {
                        stack.push("#f");
                    }
                    break;
                case ">=":
                    if (comparing() <= 0) {
                        stack.push("#t");
                    } else {
                        stack.push("#f");
                    }
                    break;
                case "<=":
                    if (comparing() >= 0) {
                        stack.push("#t");
                    } else {
                        stack.push("#f");
                    }
                    break;
                case "?":
                    terOp(stack.pop());
                    break;
                default:
                    add(token, variables);
                    break;
            }
        }
    }
} 
