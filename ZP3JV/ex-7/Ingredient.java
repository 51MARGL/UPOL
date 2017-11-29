/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package kudryashov.zp3jv.s07;

/**
 *
 * @author 97pib
 */
public class Ingredient {
    private String name;
    private String unit;
    private double price;
    
    Ingredient(String name, String unit, double price) {
        this.name = name;
        this.unit = unit;
        this.price = price;
    }
    
    public String getName() {
        return name;
    }
    
    public String getUnit() {
        return unit;
    }
    
    public double getPrice() {
        return price;
    }
}
