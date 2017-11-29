/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package cv.pkg10;

/**
 *
 * @author 97pib
 */
class StudentDBException extends Exception {

    public StudentDBException(String message) {
        super(message);
    }

    public StudentDBException(String message, Throwable cause) {
        super(message, cause);
    }
}
