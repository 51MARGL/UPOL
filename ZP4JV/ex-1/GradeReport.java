/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package cv.pkg1;

import java.util.ArrayList;

/**
 *
 * @author Kudryashov
 */
class GradeReport {

    private String name;
    private String program;
    private ArrayList<Course> courses = new ArrayList<>();

    public GradeReport() {
    }

    public GradeReport(String name, String program, ArrayList<Course> courses) {
        this.name = name;
        this.program = program;
        this.courses = courses;
    }

    public String getName() {
        return name;
    }

    public void setName(String value) {
        this.name = value;
    }

    public String getProgram() {
        return program;
    }

    public void setProgram(String value) {
        this.program = value;
    }

    public ArrayList<Course> getCourses() {
        return courses;
    }

    public void setCourses(ArrayList<Course> value) {
        this.courses = value;
    }

    @Override
    public String toString() {

        StringBuilder s = new StringBuilder();
        s.append("Full name: " + name + "\n" + "Program: " + program + "\n");
        for (Course a : courses) {
            s.append("---" + "Name: " + a.getName()
                    + " - Credits: " + a.getCredits()
                    + " - Date: " + a.getDate()
                    + " - Value: " + a.getValue() + "\n");
        }
        return s.toString();
    }
}
