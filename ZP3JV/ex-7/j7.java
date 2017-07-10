/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package kudryashov.zp3jv.s07;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.stream.Collectors;

/**
 *
 * @author 97pib
 */
public class j7 {

    /**
     * @param args the command line arguments
     */
    public static int[] odd(int[] foo){
        return Arrays.stream(foo)
                .filter(p -> p % 2 == 1)
                .toArray();
    }
     
    public static List<Integer> oddNumbers(List<Integer> foo){
        return foo
                .stream()
                .filter(p -> p % 2 == 1)
                .collect(Collectors.toList());
    } 
    public static void main(String[] args) {
        System.out.println("Task 1:");
        int[] foo = {1, 2, 3, 4, 5, 6, 7, 8, 11, 13, 15};
        Arrays.stream(odd(foo))
                .forEach (x -> System.out.print(x + ", "));
        System.out.println();
        List<Integer> foo2 = Arrays
                .asList(1, 2, 3, 4, 5, 6, 7, 8, 11, 13, 15);
        oddNumbers(foo2)
                .stream()
                .forEach(p -> System.out.print(p + ", "));
        
        System.out.println("\n\nTask 2:");
        Ingredient tea = new Ingredient("tea", "bag", 1.5);
        Ingredient water = new Ingredient("water", "cup", 0);
        Ingredient sugar = new Ingredient("sugar", "spoon", 0.1);
        List<Ingredient> ing = new ArrayList<>();
        ing.add(tea);
        ing.add(water);
        ing.add(sugar);
        List<Integer> ammount = Arrays.asList(1, 1, 3);
        Recipe eztea = new Recipe("EzTea", ing, ammount);
        System.out.println(eztea.toString());
        System.out.println(eztea.getPrice());
        List<Ingredient> avIng = new ArrayList<>();
        System.out.println(eztea.isCookable(avIng));
        avIng.add(sugar);
        System.out.println(eztea.isCookable(avIng));
        avIng.add(tea);
        avIng.add(water);
        System.out.println(eztea.isCookable(avIng));
        eztea.getIngredientsByPrice()
                .stream()
                .forEach(x -> System.out.print(x.getPrice() 
                        + ":" + x.getName() + " "));
        System.out.println();
        System.out.println("The most expensive: " 
                + eztea.getTheMostExpensiveIngredient().getName());
    }
}
