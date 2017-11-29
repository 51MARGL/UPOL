using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace cv_7 {
    class Program {

        public static void MergeSort (Student[] names) {
            if (names.Count() >= 2) {
                Student[] left = new Student[names.Count() / 2];
                Student[] right = new Student[names.Count() - names.Count() / 2];

                for (int i = 0; i < left.Count(); i++) {
                    left[i] = names[i];
                }

                for (int i = 0; i < right.Count(); i++) {
                    right[i] = names[i + names.Count() / 2];
                }

                MergeSort(left);
                MergeSort(right);
                Merge(names, left, right);
            }
        }

        public static void Merge (Student[] names, Student[] left, Student[] right) {
            int a = 0;
            int b = 0;
            for (int i = 0; i < names.Count(); i++) {
                if (b >= right.Count() || (a < left.Count() 
                    && string.Compare(left[a].Prijmeni, right[b].Prijmeni, StringComparison.CurrentCultureIgnoreCase) < 0)) {
                    names[i] = left[a];
                    a++;
                } else {
                    names[i] = right[b];
                    b++;
                }
            }
        }


        static void Main (string[] args) {

            MergeSort(ReadonlyDB.Students);
            foreach (var item in ReadonlyDB.Students) {
                Console.WriteLine(item);
            }
            Console.WriteLine();

            List<Student> resultList = new List<Student>();
            for (int i = 4; i < ReadonlyDB.Students.Count() && i < 15; i++) {
                resultList.Add(ReadonlyDB.Students[i]);
            }
            Console.WriteLine(resultList.Count);
            for (int i = 0; i < resultList.Count - 1; i++) {
                if (resultList[i].Jmeno.CompareTo(resultList[i + 1].Jmeno) == 0
                    && resultList[i].Prijmeni.CompareTo(resultList[i + 1].Prijmeni) == 0) {
                    resultList.RemoveAt(i + 1);
                }
            }
            Console.WriteLine(resultList.Count);
            foreach (var item in resultList) {
                Console.WriteLine(item);
            }
            Console.WriteLine();
            ///////////

            var sortedS = ReadonlyDB.Students
                .OrderBy(p => p.Prijmeni)
                .Skip(4)
                .Take(10)
                .GroupBy(p => new { p.Jmeno, p.Prijmeni })
                .Select(g => g.First());

            foreach (var item in sortedS) {
                Console.WriteLine(item);
            }
            Console.WriteLine();
            Console.WriteLine("5. rocnik:");
            foreach (var item in ReadonlyDB.Students.Where(p => p.Rocnik >= 5)) {
                Console.WriteLine(item);
            }
            Console.WriteLine();

            Console.WriteLine("MI counnt= " + ReadonlyDB.Students.Count(p => p.OborKomb == "MI"));
            Console.WriteLine();

            Console.WriteLine("Zdeněk: " + ReadonlyDB.Students.Any(p => p.Jmeno == "Zdeněk"));
        }
    }
}
