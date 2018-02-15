/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package cv.pkg1;

import java.io.InputStream;
import java.io.OutputStream;
import java.util.ArrayList;
import javax.xml.stream.XMLInputFactory;
import javax.xml.stream.XMLOutputFactory;
import javax.xml.stream.XMLStreamException;
import javax.xml.stream.XMLStreamReader;
import javax.xml.stream.XMLStreamWriter;

/**
 *
 * @author Kudryashov
 */
public class StAXGradeReportReaderWriter implements GradeReportReaderWriter {

    @Override
    public GradeReport loadGradeReport(InputStream input)
            throws XMLStreamException {

        XMLInputFactory xmlInputFactory = XMLInputFactory.newInstance();
        XMLStreamReader reader = xmlInputFactory.createXMLStreamReader(input);

        GradeReport report = new GradeReport();
        ArrayList<Course> courses = new ArrayList<>();

        String el = "";

        while (reader.hasNext()) {

            switch (reader.next()) {
                case XMLStreamReader.START_ELEMENT:
                    el = reader.getName().toString();
                    
                    break;
                case XMLStreamReader.END_ELEMENT:
                    el = "";
                    break;
                case XMLStreamReader.CHARACTERS:
                    switch (el) {
                        case "name":
                            report.setName(reader.getText());
                            break;
                        case "program":
                            report.setProgram(reader.getText());
                            break;
                        case "course":
                            courses.add(new Course(
                                reader.getAttributeValue(null, "name"),
                                Integer.valueOf(reader.getAttributeValue(null, "credits")),
                                reader.getAttributeValue(null, "date"),
                                reader.getText()));
                            break;
                    }
                    break;
            }
        }
        report.setCourses(courses);
        return report;
    }

    @Override
    public void storeGradeReport(OutputStream output, GradeReport gradeReport)
            throws XMLStreamException {

        XMLOutputFactory xmlOutputFactory = XMLOutputFactory.newInstance();
        XMLStreamWriter xmlWriter = xmlOutputFactory.createXMLStreamWriter(output);

        xmlWriter.writeStartDocument();
        xmlWriter.writeCharacters("\n");
        xmlWriter.writeStartElement("grades");

        xmlWriter.writeCharacters("\n\t");
        xmlWriter.writeStartElement("name");
        xmlWriter.writeCharacters(gradeReport.getName());
        xmlWriter.writeEndElement();

        xmlWriter.writeCharacters("\n\t");
        xmlWriter.writeStartElement("program");
        xmlWriter.writeCharacters(gradeReport.getProgram());
        xmlWriter.writeEndElement();

        xmlWriter.writeCharacters("\n\t");
        xmlWriter.writeStartElement("courses");
        for (Course c : gradeReport.getCourses()) {
            xmlWriter.writeCharacters("\n\t\t");
            xmlWriter.writeStartElement("course");
            xmlWriter.writeAttribute("name", c.getName());
            xmlWriter.writeAttribute("credits", String.valueOf(c.getCredits()));
            xmlWriter.writeAttribute("date", c.getDate());
            xmlWriter.writeCharacters(c.getValue());
            xmlWriter.writeEndElement();
        }
        xmlWriter.writeCharacters("\n\t");
        xmlWriter.writeEndElement();
        xmlWriter.writeCharacters("\n");
        xmlWriter.writeEndElement();
        xmlWriter.writeEndDocument();
    }
}
