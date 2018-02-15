/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package cv.pkg10;

import java.util.ArrayList;

public class GradeReport {

    private String name;
    private String program;
    private ArrayList<Course> courses = new ArrayList<>();

    public GradeReport() {
    }

    public GradeReport(String name, String program) {
        this.name = name;
        this.program = program;
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

    public void addCourse(Course value) {
        this.courses.add(value);
    }

    public Course getCourse(String name) {
        for (Course x : courses) {
            if (x.getName() == name) {
                return x;
            }
        }
        return null;
    }

    public void graduate(String name, String date, String mark) {
        for (Course x : courses) {
            if (x.getName() == name) {
                x.setDate(date);
                x.setValue(mark);
            }
        }
    }

    @Override
    public String toString() {

        StringBuilder s = new StringBuilder();
        s.append(name + " -|- " + program);

        return s.toString();
    }
}
