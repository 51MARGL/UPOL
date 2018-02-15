/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package kudryashov.zp3jv.s03;
import java.util.ArrayList;
import java.util.List;
import java.util.Random;
/**
 *
 * @author 97pib
 */
public class j3 {

    /**
     * @param args the command line arguments
     */
    
    public static int[] odd(int[] foo){
        int k = 0;
        for (int i = 0; i < foo.length; i++){
            if (foo[i] % 2 != 0){
                k++;
            }
        }
        int[] p = new int[k];
        for(int i = 0, j = 0; i < foo.length; i++){
            if (foo[i] % 2 != 0){
                p[j] = foo[i];
                j++;
            }
        }
        return p;
    }
    
    public static List<Object> odd(List<Object> foo){
        List<Object> lst = new ArrayList<>();
        for (Object n : foo){
            if (n instanceof Integer){
                if ((int)n % 2 != 0) lst.add(n);
            }
        }
        return lst;
    }
    
    public static List<Integer> oddNumbers(List<Integer> foo){
        List<Integer> lst = new ArrayList<>();
        for (int n : foo){
            if (n % 2 != 0){
                lst.add(n);
            }
        }
        return lst;
    }   
    
    public static Point nearest(Point p, List<Point> points){
        double min = p.distance(points.get(0));
        Point near = new Point(0, 0);
        for (Point n:points){
            if (n.distance(p) < min){
                min = n.distance(p);
                near = n;
            }
        }
        return near;
    }
    
     public static int[] merge(int[] first, int[] second){
        int iF = 0;
        int iS = 0;
        int iM = 0;
        int[] result = new int[first.length + second.length];
        while (iF < first.length && iS< second.length){
            if (first[iF] < second[iS]){
                result[iM] = first[iF];
                iF++;
            }else{
                result[iM] = second[iS];
                iS++;
            }
            iM++;
        }
        System.arraycopy(first, iF, result, iM, first.length - iF);
        System.arraycopy(second, iS, result, iM, second.length - iS);
        return result;
    }      
    
    public static List<Integer> mergeSort(List<Integer> a){
        List<Integer> left = new ArrayList<>();
        List<Integer> right = new ArrayList<>();
        if (a.size() <= 1){
            return a;
        }else{
            int mid = a.size() / 2;
            for (int n : a) {
                if (a.indexOf(n) < mid){
                    if (!left.contains(n)){
                        left.add(n);
                    }
                }else{
                    if (!right.contains(n)){
                        right.add(n);   
                    }
                }
            }
            right = mergeSort(right);
            left = mergeSort(left);
            return merge(left, right);
        }
    } 
    
    public static List<Integer> merge(List<Integer> a, List<Integer> b){
        List<Integer> res = new ArrayList<>();
        System.out.print("Current Time in milliseconds = ");
        System.out.println(System.currentTimeMillis());
        System.currentTimeMillis();
        while (!a.isEmpty()  && !b.isEmpty()){
            if (a.get(0) < b.get(0)){
                res.add(a.get(0));
                a.remove(0);
            }else{
                res.add(b.get(0));
                b.remove(0);
            }
        }
        res.addAll(a);
        res.addAll(b);
        return res;
    } 
     
    public static void main(String[] args) {
       
        int[] foo = {1, 2, 3, 4, 5, 6, 7, 8, 11, 13, 15};
        System.out.println("1st task:");
        for (int n : odd(foo)){
            System.out.print(n + ", ");
        }
       
       
        System.out.println("\n\n2nd task:");
        List<Object> foo1 = new ArrayList<>();
        for (int n : foo){
            foo1.add(n);
        }
        foo1.add(5.5);
        for (Object n : odd(foo1)){
            System.out.print(n + ", ");
        }
       
       
        System.out.println("\n\n3rd task:");
        List<Integer> foo2 = new ArrayList<>();
        for (int i = 5; i < 15; i++){
            foo2.add(i);
        }
        for (int n : oddNumbers(foo2)){
            System.out.print(n + ", ");
        }
       
       
        System.out.println("\n\n4th task:");
        List<Point> points = new ArrayList<>();
        Point p1 = new Point(0, 5);
        Point p2 = new Point(5, 0);
        Point p3 = new Point(-5, 0);
        Point p4 = new Point(0, -5);
        points.add(p1);
        points.add(p2);
        points.add(p3);
        points.add(p4);
        Point control = new Point(-10, 0);
        Point result =nearest(control, points);
        System.out.println("x=" + result.x + " y=" + result.y);
       
       
        System.out.println("\n5th task:");
        int[] foo3 = {16, 18, 22, 23, 25};
        for (int n : merge(foo, foo3)){
            System.out.print(n + ", ");
        }
        System.out.print("\n");
        List<Integer> foo4 = new ArrayList<>();
        for (int i = 15; i < 25; i++){
            foo4.add(i);
        }
        for (int n : merge(foo2, foo4)){
            System.out.print(n + ", ");
        }
       
       
        System.out.println("\n\n6th task:");
        List<Integer> foo5 = new ArrayList<>();
        foo5.add(10);
        foo5.add(1);
        foo5.add(8);
        foo5.add(15);
        foo5.add(20);
        foo5.add(5);
        foo5.add(4);
        foo5.add(8);
        foo5.add(8);
        foo5.add(20);
        foo5.add(20);
        for (int n : mergeSort(foo5)){
            System.out.print(n + ", ");
        }
        
        
        System.out.println("\n\n7th task:");
        Random r = new Random();
        List<Integer> test = new ArrayList<>();
        for (int i = 0; i < 10000; i++){
            test.add(r.nextInt(100));
        }
        mergeSort(test);
    }
}
