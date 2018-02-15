using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace cv_5 {

    public class Teacher {
        public string prijmeni { get; set; }
        public string jmeno { get; set; }
        public string katedra { get; set; }
    }

    public class Teachers {
        public List<Teacher> ucitel = new List<Teacher>();
    }
}
