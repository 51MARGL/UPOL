/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package cv.pkg7;

/**
 *
 * @author 97pib
 */
public class Course {

    private String name;
    private String credits;
    private String date;
    private String value;

    public Course() {
    }

    public Course(String name, String credits) {
        this.name = name;
        this.credits = credits;
        date = null;
        value = null;
    }

    public Course(String name, String credits, String date, String value) {
        this.name = name;
        this.credits = credits;
        this.date = date;
        this.value = value;
    }

    public String getName() {
        return name;
    }

    public void setName(String value) {
        this.name = value;
    }

    public String getCredits() {
        return credits;
    }

    public void setCredits(String value) {
        this.credits = value;
    }

    public String getDate() {
        return date;
    }

    public void setDate(String value) {
        this.date = value;
    }

    public String getValue() {
        return value;
    }

    public void setValue(String value) {
        this.value = value;
    }

    @Override
    public String toString() {
        if (value == null) {
            return name + " -|- Credits: " + credits + " -|- Not graduated";
        } else {
            return name + " -|- Credits: " + credits
                    + " -|- Date: " + date + " -|- Grade: " + value;
        }
    }
}
