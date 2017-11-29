/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package cv.pkg1;

/**
 *
 * @author Kudryashov
 */
class Course {

    private String name;
    private int credits;
    private String date;
    private String value;

    public Course() {
    }

    public Course(String name, int credits, String date, String value) {
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

    public int getCredits() {
        return credits;
    }

    public void setCredits(int value) {
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
}
