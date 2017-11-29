/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package cv.pkg1;

import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.util.ArrayList;

import javax.xml.parsers.ParserConfigurationException;
import javax.xml.parsers.SAXParser;
import javax.xml.parsers.SAXParserFactory;

import org.xml.sax.Attributes;
import org.xml.sax.SAXException;
import org.xml.sax.helpers.DefaultHandler;

/**
 *
 * @author Kudryashov
 */
class SAXGradeReportReaderWriter implements GradeReportReaderWriter {

    private ArrayList<Course> courses = new ArrayList<>();
    private GradeReport report = new GradeReport();

    @Override
    public GradeReport loadGradeReport(InputStream input)
            throws ParserConfigurationException, SAXException, IOException {

        SAXParserFactory parserFactory = SAXParserFactory.newInstance();
        SAXParser parser = parserFactory.newSAXParser();

        parser.parse(input, new DefaultHandler() {

            private String el;
            private Attributes attr;

            @Override
            public void startElement(String uri, String localName,
                    String qName, Attributes attributes) throws SAXException {
                el = qName;
                attr = attributes;
               
            }

            @Override
            public void endElement(String namespaceURI,
                    String localName, String qName) throws SAXException {
                el = "";
            }

            @Override
            public void characters(char[] ch, int start, int length)
                    throws SAXException {
                switch (el) {
                    case "name":
                        report.setName(new String(ch, start, length));
                        break;
                    case "program":
                        report.setProgram(new String(ch, start, length));
                        break;
                    case "course":
                        courses.add(new Course(
                            attr.getValue("name"),
                            Integer.valueOf(attr.getValue("credits")),
                            attr.getValue("date"),
                            new String(ch, start, length)));
                        break;
                    default:
                        break;
                }
            }
        });

        report.setCourses(courses);
        return report;
    }

    @Override
    public void storeGradeReport(OutputStream output,
            GradeReport gradeReport) throws Exception {
        throw new Exception("SAX can NOT store");
    }

}
