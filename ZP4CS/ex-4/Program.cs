using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.IO;
using System.Collections;

namespace cv_4
{
    class Program
    {
        static void MergeSort(int[] A, int p, int r)
        {
            if (p < r)
            {
                int q = (p + r) / 2;
                MergeSort(A, p, q);
                MergeSort(A, q + 1, r);
                Merge(A, p, q, r);
            }
        }

        static void Merge(int[] A, int p, int q, int r)
        {
            int n1 = q - p + 1;
            int n2 = r - q;
            int[] L = new int[n1 + 1];
            int[] R = new int[n2 + 1];
            for (int i = 0; i < n1; i++)
            {
                L[i] = A[p + i];
            }
            for (int j = 0; j < n2; j++)
            {
                R[j] = A[q + j + 1];
            }
            L[n1] = int.MaxValue;
            R[n2] = int.MaxValue;
            int n = 0;
            int m = 0;
            for (int k = p; k <= r; k++)
            {
                if (L[n] <= R[m])
                {
                    A[k] = L[n];
                    n++;
                }
                else
                {
                    A[k] = R[m];
                    m++;
                }
            }
        }

        static void ReadFile()
        {
            FileInfo f = new FileInfo(@"D:\test.txt");
            if (f.Exists)
            {
                StreamReader sr = null;
                List<int> array = new List<int>();
                try
                {
                    sr = f.OpenText();
                    string s = "";
                    while ((s = sr.ReadLine()) != null)
                    {
                        string[] bits = s.Split(' ');
                        foreach (var it in bits)
                        {
                            array.Add(int.Parse(it));
                        }
                    }

                    int[] arr = array.ToArray();
                    MergeSort(arr, 0, array.Count - 1);
                    foreach (var item in arr)
                    {
                        Console.Write(item + ", "); 
                    }
                    WriteFile(arr);
                }
                catch (Exception e)
                {
                    Console.WriteLine("Chyba pri cteni souboru");
                }
                finally
                {
                    if (sr != null)
                    {
                        sr.Close();
                    }

                }
            }
        }

        static void WriteFile(int[] arr)
        {
            StreamWriter sw = null;
            try
            {
                sw = new StreamWriter(File.Create(@"D:\test2.txt"));
                for (int i = 0; i < arr.Length; i++)
                {
                    sw.WriteLine(arr[i] + " ");
                }
            }
            catch (Exception e)
            {
                Console.WriteLine("Zapis souboru selhal");
            }
            finally
            {
                if (sw != null)
                {
                    sw.Close();
                }

            }
        }
            static void Main(string[] args)
        {
            Mycmd c = new Mycmd();
            c.Start();
            ReadFile();
            Console.ReadLine();
        }
    }
}
