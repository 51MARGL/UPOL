/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package kudryashov.zp3jv.s05;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

/**
 *
 * @author 97pib
 */
public class j5 {
        
    public static List<Object> map(List<Object> list, Mapping m) {
        List<Object> res = new ArrayList();
        list.forEach (n -> res.add(m.map(n)));
        return res;
    }
    
    public static List<Object> filter(List<Object> list, Condition c) {
        List<Object> res = new ArrayList();
        for (Object item : list) {
            if (c.test((int)item)) {
                res.add(item);
            }
        }
        return res;
    }

    public static String repeatChar1(char c, int n) {
        String res = new String();
        for (int i = 0; i < n; i++) {
            res += c;
        }
        return res;
    }
    
      public static String repeatChar2(char c, int n) {
        StringBuilder res = new StringBuilder();
        for (int i = 0; i < n; i++) {
            res.append(c);
        }
        return res.toString();
    }
    
    
    public static void main(String[] args) {
        System.out.println("\nTask 1 :");
        List l = Arrays.asList(1, 2, 3, 4, 5, 6, 7, 8, 9);
        Mapping add = (a) -> (int)a + 1;
        for (Object n : map(l,add)) {
            System.out.print(n + ", ");
        }
        
        System.out.println("\nTask 2 :");
        Condition c = (n) -> n % 2 == 1;
        for (Object n : filter(l, c)) {
            System.out.print(n + ", ");
        }
        
        Condition c1 = new Condition() {
            @Override
            public boolean test(int x){
                return x % 2 == 1;
            }
        };
        System.out.println();
        for (Object n : filter(l, c1)) {
            System.out.print(n + ", ");
        }
        System.out.println();
        Upper u = new Upper();
        Upper.IsOdd odd = u.new IsOdd();
        Condition c2 = odd;
        for (Object n : filter(l, c2)) {
            System.out.print(n + ", ");
        }
        
        System.out.println("\nTask 3 :");
        System.out.println(System.currentTimeMillis());
        repeatChar1('w', 100000);
        System.out.println(System.currentTimeMillis());
        repeatChar2('w', 100000);
        System.out.println(System.currentTimeMillis());
    }  
}

