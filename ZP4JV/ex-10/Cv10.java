/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package cv.pkg10;

import java.sql.Connection;
import java.sql.DatabaseMetaData;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

/**
 *
 * @author 97pib
 */
public class Cv10 {

    public static void main(String[] args) throws Exception {
        try (Connection con = DriverManager.getConnection("jdbc:derby:cv-10-3;create=true")) {
            prepareDB(con);
            doSomething(con);
        }
    }

    private static void doSomething(Connection con) throws StudentDBException, SQLException {
        try (StudentManager studentManager = new StudentManager(con); 
                CourseManager courseManager = new CourseManager(con)) {
            GradeReport rep1 = studentManager.create("Fox Mulder", "X-Files");

            GradeReport rep2 = studentManager.create("Dana Scully", "X-Files");
            studentManager.create("Someone Else", "lol");
            rep1.addCourse(courseManager.create(rep1.getName(), "UFO", 5, "12.12.12", "A"));
            
            rep1.addCourse(courseManager.create(rep1.getName(), "UFO2", 5, "12.12.13", "A"));
            rep2.addCourse(courseManager.create("Dana Scully", "Meds", 1));

            listAllStudents(studentManager, courseManager);
            
            rep2.graduate("Meds", "10.10.12", "A");
            courseManager.commitChanges(rep2.getCourse("Meds"), rep2.getName());
            listAllStudents(studentManager, courseManager);
            
            studentManager.remove(rep1);
            listAllStudents(studentManager, courseManager);
        }
    }

    private static void listAllStudents(StudentManager employeeManager, CourseManager courseManager) throws StudentDBException, SQLException {
        System.out.println("Students:");
        for (String empName : employeeManager.getStudentNames()) {
            GradeReport emp = employeeManager.getByName(empName);
            System.out.println(emp);
            System.out.println("\t\tCourses:");
            for(String cName : courseManager.getCoursesNames(empName)){
                Course c = courseManager.getByName(cName);
                System.out.println("\t\t" + c);
            }
        }
    }

    /**
     * Inicializuje tabulky v databazi
     *
     * @throws SQLException
     */
    private static void prepareDB(Connection con) throws SQLException {
        try (Statement stmt = con.createStatement()) {
            if (!isReady(con, "STUDENTS")) {
                stmt.executeUpdate("CREATE TABLE students (name VARCHAR(50) PRIMARY KEY, program VARCHAR(50))");
            } else {
                stmt.executeUpdate("DELETE FROM students");
            }
            if (!isReady(con, "COURSES")) {
                stmt.executeUpdate("CREATE TABLE courses (sname VARCHAR(50), name VARCHAR(50), credits int, date VARCHAR(15), mark VARCHAR(2))");
            } else {
                stmt.executeUpdate("DELETE FROM courses");
            }
        }
    }

    /**
     * Vraci true pokud databazi existuje tabulka 
     */
    private static boolean isReady(Connection con, String table) throws SQLException {
        DatabaseMetaData dbm = con.getMetaData();
        try (ResultSet tables = dbm.getTables(null, null, table, null)) {
            return tables.next();
        }
    }
}
