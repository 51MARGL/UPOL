using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace cv_5 {

    public class Student {
        public string prijmeni { get; set; }
        public string jmeno { get; set; }
        public int rocnik { get; set; }
    }

    public class StudentList {
        public List<Student> studentiPredmetu = new List<Student>();
    }
}
