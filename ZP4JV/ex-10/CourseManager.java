/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package cv.pkg10;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

/**
 *
 * @author 97pib
 */
public class CourseManager implements AutoCloseable {

    private PreparedStatement getAllNames;
    private PreparedStatement getByNameStmt;
    private PreparedStatement insertStmt;
    private PreparedStatement insertStmt2;
    private PreparedStatement updateStmt;
    private PreparedStatement deleteStmt;
    private Connection con;

    public CourseManager(Connection con) throws StudentDBException {
        this.con = con;
        try {
            getAllNames = con.prepareStatement("SELECT name FROM courses WHERE sname = ?");
            getByNameStmt = con.prepareStatement("SELECT * FROM courses WHERE name = ?");
            insertStmt = con.prepareStatement("INSERT INTO courses (sname,name,credits,date,mark) VALUES (?, ?, ?, ?, ?)");
            insertStmt2 = con.prepareStatement("INSERT INTO courses (sname,name,credits) VALUES (?, ?, ?)");
            updateStmt = con.prepareStatement("UPDATE courses SET name = ?, credits = ?, date = ?, mark = ?  WHERE name = ? AND sname = ?");
            deleteStmt = con.prepareStatement("DELETE FROM courses WHERE sname = ? AND name = ?");
        } catch (SQLException e) {
            throw new StudentDBException("Unable to initialize prepared statements.", e);
        }
    }

    public List<String> getCoursesNames(String name) throws StudentDBException, SQLException {
        List<String> names = new ArrayList<String>();
        getAllNames.setString(1, name);
        try {
            try (ResultSet results = getAllNames.executeQuery()) {
                while (results.next()) {
                    names.add(results.getString(1));
                }
            }
        } catch (Exception e) {
            throw new StudentDBException("Unable to list all courses");
        }
        return names;
    }

    public Course getByName(String name) throws StudentDBException {
        Course crs = null;
        try {
            getByNameStmt.setString(1, name);
            try (ResultSet results = getByNameStmt.executeQuery()) {
                if (results.next()) {
                    crs = new Course(results.getString("name"),
                            String.valueOf(results.getInt("credits")),
                            results.getString("date"),
                            results.getString("mark"));
                }
            }
        } catch (SQLException e) {
            throw new StudentDBException("Unable to find a course", e);
        }
        return crs;
    }

    public Course create(String sname, String name, int credits, String date, String mark) throws StudentDBException {
        try {
            insertStmt.setString(1, sname);
            insertStmt.setString(2, name);
            insertStmt.setInt(3, credits);
            insertStmt.setString(4, date);
            insertStmt.setString(5, mark);
            insertStmt.executeUpdate();

            return new Course(name, String.valueOf(credits), date, mark);
        } catch (SQLException e) {
            throw new StudentDBException("Unable to create new course", e);
        }
    }
    
    public Course create(String sname, String name, int credits) throws StudentDBException {
        try {
            insertStmt2.setString(1, sname);
            insertStmt2.setString(2, name);
            insertStmt2.setInt(3, credits);
            insertStmt2.executeUpdate();

            return new Course(name, String.valueOf(credits));
        } catch (SQLException e) {
            throw new StudentDBException("Unable to create new course", e);
        }
    }

    public void remove(Course course, String sname) throws StudentDBException {
        try {
            deleteStmt.setString(1, sname);
            deleteStmt.setString(2, course.getName());
            deleteStmt.executeUpdate();
        } catch (SQLException e) {
            throw new StudentDBException("Unable to delete course", e);
        }
    }
    
    

    public void commitChanges(Course course, String sname) throws StudentDBException {
        try {
            updateStmt.setString(1, course.getName());
            updateStmt.setInt(2, Integer.parseInt(course.getCredits()));
            updateStmt.setString(3, course.getDate());
            updateStmt.setString(4, course.getValue());
            updateStmt.setString(5, course.getName());
            updateStmt.setString(6, sname);
            updateStmt.executeUpdate();
        } catch (SQLException e) {
            throw new StudentDBException("Unable to update course", e);
        }
    }

    @Override
    public void close() {
        try {
            getAllNames.close();
            getByNameStmt.close();
            insertStmt.close();
            insertStmt2.close();
            updateStmt.close();
            deleteStmt.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}
