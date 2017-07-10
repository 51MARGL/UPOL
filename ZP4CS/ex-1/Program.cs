using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ConsoleApplication12
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
            int[] L = new int[n1+1];
            int[] R = new int[n2+1];
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
                if(L[n] <= R[m])
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

        static void Main(string[] args)
        {
            int[] pole = { 4,3,2,1, 5, 4, 2 };
            foreach (int x in pole)
            {
                Console.Write(x + " ");
            }
            Console.WriteLine();
            MergeSort(pole, 0, pole.Length-1);
            foreach (int x in pole)
            {
                Console.Write(x + " ");
            }
            Console.WriteLine();
        }
    }
}
