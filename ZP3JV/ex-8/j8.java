/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package kudryashov.zp3jv.s08;

import java.util.HashMap;
import java.util.Map;

/**
 * <h1>8. Task of ZP3JV</h1>
 * The j8 program implements a RPN-calculator
 * @author Serhiy Kudryashov
 * @version 1.0 12/11/2016
 */
public class j8 {

    
    /**
     * Main methods makes tests of RPN-calculator
     * @param args the command line arguments
     */
    public static void main(String[] args) {
        Map<String, Integer> f = new HashMap<>();
        Calculator calc = new Calculator();
        f.put("foo", 2);
        f.put("boo", 5);
        calc.rpnCalc("1 0 /");
        calc.rpnCalc("1 foo +", f);
        calc.rpnCalc("boo foo * 5 -", f);
        calc.rpnCalc("2 1.0 >");
        calc.rpnCalc("2.0 3.0 >");
        calc.rpnCalc("1 1.0 =");
        calc.rpnCalc("1 1.0 !=");
        calc.rpnCalc("#t #f >");
        calc.rpnCalc("#t #f <");
        calc.rpnCalc("1 #t =");
        calc.rpnCalc("1 2 3 4 < ?");
        calc.rpnCalc("1 2 3 4 > ?");
        calc.rpnCalc("1 2 3 4 + ?");
    }
}
