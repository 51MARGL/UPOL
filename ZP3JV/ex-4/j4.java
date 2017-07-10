/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package kudryashov.zp3jv.s04;

import java.util.ArrayList;
import java.util.List;

/**
 *
 * @author 97pib
 */
public class j4 {

    /**
     * @param format
     * @param args the command line arguments
     * @return 
     */
    public static String formatStr(String format, Object... args) {
        StringBuilder result = new StringBuilder(format);
        for (int i = 0; i < format.length()-1; i++){
            if (result.charAt(i) == '%'){
                int j = Character.getNumericValue(result.charAt(i+1));
                if(j >= 0) result.replace(i, i+2, args[j].toString());
            }
        }
        return result.toString();
    }
  
    public static void main(String[] args) {
        List<Number> l1 = new ArrayList<>();
        l1.add(1);
        l1.add(2.5);
        l1.add(3);
        NumericList<Number> test = new NumericList<>(l1);
        System.out.println("NumericList :");
        for (Object n : test.list){
            System.out.print(n + ", ");
        }
        System.out.println("\nFirst = " + test.first());
        System.out.println("Without First :");
        for (Object n : test.next().list){
            System.out.print(n + ", ");
        }
        System.out.println("\nSize = " + test.size());
        System.out.println("Sum = " + test.sum());
        
        
        System.out.println("\nTask2 : ");
        System.out.println(formatStr("A: %0; B: %1", 1, "XY"));
        
        
        System.out.println("\nTask3 : ");
        AnimalFarm f = new AnimalFarm();
        f.add("Alík", "dog", "m");
        f.add("Bobík", "duck", "w");
        f.add("Chubaka ", "dog", "w");
        f.add("Donald ", "duck", "m");
        f.list();
    }
}
