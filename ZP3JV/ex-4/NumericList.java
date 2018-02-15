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
public class NumericList<T> {
    
    public List<? extends Number> list;
    
    public NumericList(List<? extends Number> list) {
        this.list = list;
    }
    public T first() {
        return (T)list.get(0);
    }
    
    public NumericList<T> next() {
        if (!(list.size() == 1)) {
            List<T> newList = new ArrayList<>();
            newList = (List<T>) list.subList(1, list.size());
            NumericList<T> res;
            res = new NumericList<>((List<? extends Number>)newList);
            return res;
        }else{
            return null;
        }
    }
    
    public int size() {
        return list.size();
    } 
    
    public double sum() {
        double suma = 0;
        for (Number n : list) {
            if (n instanceof Float) {
                suma += (float)(Object)n;
            }else if (n instanceof Integer) {
                suma += (int)(Object)n;   
            }else if (n instanceof Double) {
                suma += (double)(Object)n;   
            }else{
                System.out.println("\nCant do that!");
            }
        }
        return suma;
    }
}
