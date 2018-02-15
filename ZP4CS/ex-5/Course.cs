using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Xml.Serialization;

namespace cv_5 {

    [XmlRoot("getPredmetyByKatedraFullInfoResponse", Namespace = "http://stag-ws.zcu.cz/")]

    public class getCourses {
        [XmlArray("predmetyKatedryFullInfo", Namespace = "")]
        public List<predmetKatedryFullInfo> courselist { get; set; }

        public class predmetKatedryFullInfo {
            [XmlElement("katedra")]
            public string katedra { get; set; }
            [XmlElement("zkratka")]
            public string zkratka { get; set; }
            [XmlElement("nazev")]
            public string nazev { get; set; }
        }
    }
}
