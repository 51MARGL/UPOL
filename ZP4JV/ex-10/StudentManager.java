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

public class StudentManager implements AutoCloseable {

    private PreparedStatement getAllNames;
    private PreparedStatement getByNameStmt;
    private PreparedStatement insertStmt;
    private PreparedStatement updateStmt;
    private PreparedStatement deleteStmt;
    private PreparedStatement deleteStmt2;

    public StudentManager(Connection con) throws StudentDBException {
        try {
            getAllNames = con.prepareStatement("SELECT name FROM students");
            getByNameStmt = con.prepareStatement("SELECT * FROM students WHERE name = ?");
            insertStmt = con.prepareStatement("INSERT INTO students (name, program) VALUES (?, ?)");
            updateStmt = con.prepareStatement("UPDATE students SET name = ?, program = ? WHERE name = ?");
            deleteStmt = con.prepareStatement("DELETE FROM students WHERE name = ?");
            deleteStmt2 = con.prepareStatement("DELETE FROM courses WHERE sname = ?");
        } catch (SQLException e) {
            throw new StudentDBException("Unable to initialize prepared statements.", e);
        }
    }

    public List<String> getStudentNames() throws StudentDBException {
        List<String> names = new ArrayList<String>();
        try {
            try (ResultSet results = getAllNames.executeQuery()) {
                while (results.next()) {
                    names.add(results.getString(1));
                }
            }
        } catch (Exception e) {
            throw new StudentDBException("Unable to list all students");
        }
        return names;
    }

    public GradeReport getByName(String name) throws StudentDBException {
        GradeReport st = null;
        try {
            getByNameStmt.setString(1, name);
            try (ResultSet results = getByNameStmt.executeQuery()) {
                if (results.next()) {
                    st = new GradeReport(results.getString("name"),
                            results.getString("program"));
                }
            }
        } catch (SQLException e) {
            throw new StudentDBException("Unable to find an student", e);
        }

        return st;
    }

    public GradeReport create(String name, String program) throws StudentDBException {
        try {
            insertStmt.setString(1, name);
            insertStmt.setString(2, program);
            insertStmt.executeUpdate();

            return new GradeReport(name, program);
        } catch (SQLException e) {
            throw new StudentDBException("Unable to create new student", e);
        }
    }

    public void remove(GradeReport student) throws StudentDBException {
        try {
            deleteStmt.setString(1, student.getName());
            deleteStmt2.setString(1, student.getName()); 
            deleteStmt2.executeUpdate();
            deleteStmt.executeUpdate();
            
        } catch (SQLException e) {
            throw new StudentDBException("Unable to delete student", e);
        }
    }

    public void commitChanges(GradeReport student) throws StudentDBException {
        try {
            updateStmt.setString(1, student.getName());
            updateStmt.setString(2, student.getProgram());
            updateStmt.setString(3, student.getName());
            updateStmt.executeUpdate();
        } catch (SQLException e) {
            throw new StudentDBException("Unable to update student", e);
        }
    }

    @Override
    public void close() {
        try {
            getAllNames.close();
            getByNameStmt.close();
            insertStmt.close();
            updateStmt.close();
            deleteStmt.close();
            deleteStmt2.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}
