using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Xml;
using System.Web.Script.Serialization;
using System.IO;
using System.Xml.Serialization;

namespace cv_5 {

    class Program {

        static void ReadStudentsWriteSecondYear(string inPath, string outPath) {
            try {
                XmlDocument doc = new XmlDocument();
                doc.Load(inPath);
                XmlNodeList root = doc.GetElementsByTagName("studentiPredmetu");
                TextWriter tw = new StreamWriter(outPath);
                StudentList sList = new StudentList();
                foreach (XmlNode node1 in root) {
                    foreach (XmlNode node in node1.ChildNodes) {
                        foreach (XmlNode child in node.ChildNodes) {
                            if (child.Name == "rocnik" && child.InnerText == "2") {
                                Student i = new Student() {
                                    rocnik = int.Parse(node["rocnik"].InnerText),
                                    jmeno = node["jmeno"].InnerText,
                                    prijmeni = node["prijmeni"].InnerText
                                };
                                sList.studentiPredmetu.Add(i);
                            }
                        }
                    }
                }
                var json = new JavaScriptSerializer().Serialize(sList);
                tw.WriteLine(json);
                tw.Close();

            } catch (Exception e) {
                Console.WriteLine("Error: " + e.Message);
            }
        }

        static void ReadTeachersWritePeters(string inPath, string outPath) {
            try {
                XmlDocument doc = new XmlDocument();
                XmlDeclaration xmlDeclaration = doc.CreateXmlDeclaration("1.0", "UTF-8", null);
                XmlElement teachers = doc.CreateElement("teachers");
                doc.AppendChild(teachers);

                string text = File.ReadAllText(inPath);
                List<Teachers> deserialized = (List<Teachers>)new JavaScriptSerializer().Deserialize(text, typeof(List<Teachers>));
                foreach (var teachersL in deserialized) {
                    foreach (var teacher in teachersL.ucitel) {
                        if (teacher.jmeno == "Petr") {
                            XmlElement item = doc.CreateElement("teacher");

                            XmlElement jmeno = doc.CreateElement("jmeno");
                            jmeno.InnerText = teacher.jmeno;
                            item.AppendChild(jmeno);

                            XmlElement prijmeni = doc.CreateElement("prijmeni");
                            prijmeni.InnerText = teacher.prijmeni;
                            item.AppendChild(prijmeni);

                            XmlElement katedra = doc.CreateElement("katedra");
                            katedra.InnerText = teacher.katedra;
                            item.AppendChild(katedra);

                            teachers.AppendChild(item);
                        }
                    }
                }

                XmlTextWriter xmlTextWriter = new XmlTextWriter(outPath, Encoding.UTF8);
                xmlTextWriter.Formatting = Formatting.Indented;
                doc.WriteContentTo(xmlTextWriter);
                xmlTextWriter.Close();
            } catch (Exception e) {
                Console.WriteLine("Error: " + e.Message);
            }
        }

        static void DeserializeSubjectsWriteFirstN(string inPath, string outPath, int count) {
            try {
                XmlSerializer serializer = new XmlSerializer(typeof(getCourses));
                FileStream fileStream = new FileStream(inPath, FileMode.Open); 
                getCourses result = (getCourses)serializer.Deserialize(fileStream);
                getCourses writeFirst = new getCourses();
                writeFirst.courselist = result.courselist.GetRange(0, count);

                TextWriter tw = new StreamWriter(outPath);
                XmlSerializer sr = new XmlSerializer(typeof(getCourses));
                sr.Serialize(tw, writeFirst);
                tw.Close();
            } catch (Exception e) {
                Console.WriteLine("Error: " + e.Message);
            }
        }

        static void Main(string[] args) {
            ReadStudentsWriteSecondYear(@"D:\studentiPredmetu.xml", @"D:\druhaci.json");
            ReadTeachersWritePeters(@"D:\uciteleKatedry.json", @"D:\peters.xml");
            DeserializeSubjectsWriteFirstN(@"D:\predmetyKatedry.xml", @"D:\firstNSubjects.xml", 20);
            Console.WriteLine("DONE!!!!");
            Console.ReadLine();
        }
    }
}
