/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package cv.pkg1;

import java.io.ByteArrayOutputStream;
import java.io.DataInputStream;
import java.io.FileInputStream;
import java.io.InputStream;
import java.io.OutputStream;

/**
 *
 * @author Kudryashov
 */
public class Cv1 {

    /**
     * @param args the command line arguments
     */
    public static void main(String[] args) {

        try {
            InputStream input
                    = new DataInputStream(new FileInputStream("src\\grades.XML"));
            OutputStream output = new ByteArrayOutputStream();

            System.out.println("DOM:\n");
            DOMGradeReportReaderWriter dom = new DOMGradeReportReaderWriter();
            GradeReport reportD = dom.loadGradeReport(input);
            dom.storeGradeReport(output, reportD);
            System.out.println(reportD.toString());
            System.out.println(output);

            System.out.println("SAX:\n");
            input = new DataInputStream(new FileInputStream("src\\grades.XML"));
            SAXGradeReportReaderWriter sax = new SAXGradeReportReaderWriter();
            GradeReport reportS = sax.loadGradeReport(input);
            System.out.println(reportS.toString());

            System.out.println("StAX:\n");
            input = new DataInputStream(new FileInputStream("src\\grades.XML"));
            output = new ByteArrayOutputStream();
            StAXGradeReportReaderWriter stax = new StAXGradeReportReaderWriter();
            GradeReport reportSt = stax.loadGradeReport(input);
            System.out.println(reportSt.toString());
            stax.storeGradeReport(output, reportSt);
            System.out.println(output.toString());

        } catch (Exception e) {
            System.err.println("Error: " + e.getMessage());
        }
    }
}
