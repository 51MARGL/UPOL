/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package cv.pkg1;

import java.io.InputStream;
import java.io.OutputStream;
import java.util.ArrayList;
import org.w3c.dom.Document;
import org.w3c.dom.Element;
import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.transform.OutputKeys;
import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.dom.DOMSource;
import javax.xml.transform.stream.StreamResult;

/**
 *
 * @author Kudryashov
 */
public class DOMGradeReportReaderWriter implements GradeReportReaderWriter {

    @Override
    public GradeReport loadGradeReport(InputStream input)
            throws Exception {

        DocumentBuilderFactory documentBuilderFactory
                = DocumentBuilderFactory.newInstance();
        DocumentBuilder documentBuilder
                = documentBuilderFactory.newDocumentBuilder();
        Document doc = documentBuilder.parse(input);

        ArrayList<Course> courses = new ArrayList<>();
        for (int i = 0; i < doc.getElementsByTagName("course").getLength(); i++) {

            Course course = new Course(
                    getContentAttr(doc, "course", "name", i),
                    Integer.valueOf(getContentAttr(doc, "course", "credits", i)),
                    getContentAttr(doc, "course", "date", i),
                    doc.getElementsByTagName("course").item(i).getTextContent()
            );
            courses.add(course);
        }

        GradeReport report = new GradeReport(
                doc.getElementsByTagName("name")
                        .item(0).getTextContent(),
                doc.getElementsByTagName("program")
                        .item(0).getTextContent(),
                courses);
        return report;
    }

    @Override
    public void storeGradeReport(OutputStream output, GradeReport gradeReport)
            throws Exception {

        DocumentBuilderFactory documentBuilderFactory
                = DocumentBuilderFactory.newInstance();
        DocumentBuilder documentBuilder
                = documentBuilderFactory.newDocumentBuilder();
        Document doc = documentBuilder.newDocument();

        Element root = doc.createElement("grades");
        doc.appendChild(root);

        Element nodeN = doc.createElement("name");
        nodeN.setTextContent(gradeReport.getName());
        root.appendChild(nodeN);

        Element nodeP = doc.createElement("program");
        nodeP.setTextContent(gradeReport.getProgram());
        root.appendChild(nodeP);

        Element nodeC = doc.createElement("courses");
        root.appendChild(nodeC);

        for (Course c : gradeReport.getCourses()) {
            Element nc = doc.createElement("course");
            nc.setAttribute("name", c.getName());
            nc.setAttribute("credits", String.valueOf(c.getCredits()));
            nc.setAttribute("date", c.getDate());
            nc.setTextContent(c.getValue());
            nodeC.appendChild(nc);
        }

        TransformerFactory transformerFactory
                = TransformerFactory.newInstance();
        Transformer transformer
                = transformerFactory.newTransformer();
        transformer.setOutputProperty(OutputKeys.INDENT, "yes");

        DOMSource source = new DOMSource(doc);
        StreamResult result = new StreamResult(output);
        transformer.transform(source, result);
    }

    private String getContentAttr(Document doc, String name, String attribute, int index) {
        return doc.getElementsByTagName(name).item(index)
                .getAttributes().getNamedItem(attribute)
                .getTextContent();
    }
}
