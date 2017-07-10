/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package cv2.server;

import java.util.ArrayList;

/**
 *
 * @author Kudryashov
 */
public class User {

    private String name;
    private String password;
    private ArrayList<String> msg;

    public User(String name, String pass) {
        this.name = name;
        this.password = pass;
        this.msg = new ArrayList<>();
    }

    public String getName() {
        return name;
    }

    public String getPassword() {
        return password;
    }

    public synchronized ArrayList<String> getMSG() {
        return msg;
    }

    public synchronized void addMSG(String msgLine) {
        msg.add(msgLine);
    }

    public synchronized void clearMSG() {
        msg.clear();
    }
}
