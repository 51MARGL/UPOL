/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package cv.pkg1;

import java.io.InputStream;
import java.io.OutputStream;

/**
 *
 * @author Kudryashov
 */
public interface GradeReportReaderWriter {

    /**
     * Nacte ze streamu XML soubor a dle nej vytvori prislusny objekt tridy
     * GradeReport
     */
    public GradeReport loadGradeReport(InputStream input) throws Exception;

    /**
     * Ulozi do prislusneho streamu XML soubor predstavujici dane hodnoceni
     * studenta
     */
    public void storeGradeReport(OutputStream output, GradeReport gradeReport) throws Exception;
}
