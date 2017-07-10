/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package kudryashov.zp3jv.s07;

import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;

/**
 *
 * @author 97pib
 */
public class Recipe {
    private final String name;
    private List<Ingredient> list = new ArrayList<>();
    private List<Integer> ammount = new ArrayList<>();
    
    Recipe(String name, List<Ingredient> ing, List<Integer> ammount) {
        this.name = name;
        this.list = ing;
        this.ammount = ammount;
    }
    
    @Override
    public String toString() {
        System.out.println("For " + name + ":");
        return list
                .stream()
                .map(p -> ammount.get(list.indexOf(p)) + " " + p.getUnit()
                + " of " + p.getName() + ", ")
                .collect(Collectors.joining());
    }
    
    public double getPrice() {
        System.out.print("\nPrice: ");
        return list
                .stream()
                .mapToDouble(Ingredient::getPrice)
                .sum();
    }
    
    public boolean isCookable(List<Ingredient> availableIngredients) {
        List<Ingredient> x = list
                .stream()
                .filter(s -> availableIngredients.contains(s))
                .collect(Collectors.toList());
        return x.equals(list);
    }
    
    public List<Ingredient> getIngredientsByPrice() {
        return list
                .stream()
                .sorted((p1, p2) -> 
                        Double.compare(p2.getPrice(), p1.getPrice()))
                .collect(Collectors.toList());
    }
    
    public Ingredient getTheMostExpensiveIngredient() {
        return list
                .stream()
                .max((p1, p2) -> 
                        Double.compare(p1.getPrice(), p2.getPrice()))
                .get();
                
    }
}
