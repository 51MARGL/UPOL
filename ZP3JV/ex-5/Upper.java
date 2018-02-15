/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package kudryashov.zp3jv.s05;

/**
 *
 * @author 97pib
 */
public class Upper {
    class IsOdd implements Condition{
        @Override
        public boolean test(int x) {
            return x % 2 == 1;
        }
       
    }
}
