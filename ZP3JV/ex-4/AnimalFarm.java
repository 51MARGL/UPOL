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
public class AnimalFarm {
    
    List<Zvire> l = new ArrayList<>();
    
    class Zvire{
        public String name;
        public String sex;
        public Animal zv;
        Zvire(Animal zv, String name, String sex){
            this.name = name;
            this.sex = sex;
            this.zv = zv;
        }
    }
 
    public enum Animal{
        DOG("Pes", "Fena", "haf-haf"), DUCK("Kačer", "Kačena", "ga-ga");
        
        private String voice;
        private String typeM;
        private String typeW;
     
        Animal(String male, String female, String voice) {
            this.typeM = male;
            this.typeW = female;
            this.voice = voice;
            
        }
    }
    
    public void add(String name, String type, String gender) {
        Animal a = null;
        Zvire zv = null;
        if (type.equalsIgnoreCase(Animal.DOG.toString())) {
            a = Animal.DOG;
            zv = new Zvire(a, name, gender);
            
            
        }else if (type.equalsIgnoreCase(Animal.DUCK.toString())) {
            a = Animal.DUCK; 
            zv = new Zvire(a, name, gender);
        }
        l.add(zv);
    }
    
    
    public void list() {
        for(Zvire x : l){
            if("m" == x.sex)    {
                System.out.println(x.name + " je " + x.zv.typeM.toLowerCase()
                        + " a dela " 
                        + "\"" + x.zv.voice + "\"");
            }else if("w" == x.sex)  {
                System.out.println(x.name + " je " + x.zv.typeW.toLowerCase()
                        + " a dela " 
                        + "\"" + x.zv.voice + "\"");
            }
        }
    }
}

