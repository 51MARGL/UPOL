/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package kudryashov.zp3jv.s01;

/**
 *
 * @author 97pib
 */
public class j1 {

    /**
     * @param args the command line arguments
     */
    public static void main(String[] args) {
        //task1
        int n=6;
        for (int i = 0; i < n; i++){
            for (int j = 0; j < n; j++){
               if (j == n - 1 || i == n - 1 || j == n - i - 1){
                   System.out.print('*');
               }else{
                   System.out.print(' ');
               }
            }
             System.out.print('\n');
        }
        
        
        //task2
        for (int i = 0; i < n; i++){
            for (int k = 0; k < n ; k++){
                for (int j = 0; j < n; j++){
                 if (k == 0 && (j == n - i - 1 || j == n-1)){ 
                     System.out.print('*');
                 }else if (k != 0 
                         && (j == n - 2 || j == n - i - 2 || j == n-2)){ 
                     System.out.print('*');
                 }else {
                     System.out.print(" ");
                 }
                }
            }
             System.out.print('\n');
        }
        
        
        //task3
        int[] a = {10,5,-2,20,-15,0};
        int max = a[0];
        int min = max;
        System.out.print("Array: ");
        for (int i = 0; i < a.length; i++){
            if (i == a.length - 1){
                System.out.print(a[i]);
            }else{
                System.out.print(a[i] + ", ");
            }
            if (a[i] > max){
                max = a[i];
            }
            if (a[i] < min){
                min = a[i];
            }
        }
        System.out.println("\nMAX=" + max + "\nMIN=" + min);
        
        
        //task4
        for (int x, i = 2, k = 1; i < 100; i++){
            x = 0;
            for (int j = 2; j < 100; j++){
		if ((i % j == 0) && (i != j))  break; 
		if (j == 99) { 
                    x = 1;
                }
            }
            if (x == 1) { 
                System.out.print(i);
                if (k % 10 == 0){
                    System.out.print(",\n");
                }else if(i == 97){
                    System.out.print("\n");
                }else{
                    System.out.print(", ");
                }
                k++;
                }
	}
        
    }
    
}
