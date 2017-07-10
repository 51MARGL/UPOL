using System;

namespace ConsoleApplication13
{
    class Program
    {
        static void TupleMergeSort (Tuple[] A)
        {
            MergeSort(A, 0, A.Length-1);
        }
        static void MergeSort(Tuple[] A, int p, int r)
        {
            if (p < r)
            {
                int q = (p + r) / 2;
                MergeSort(A, p, q);
                MergeSort(A, q + 1, r);
                Merge(A, p, q, r);
            }
        }

        static void Merge(Tuple[] A, int p, int q, int r)
        {
            int n1 = q - p + 1;
            int n2 = r - q;
            Tuple[] L = new Tuple[n1 + 1];
            Tuple[] R = new Tuple[n2 + 1];
            Array.Copy(A, p, L, 0, L.Length - 1);
            Array.Copy(A, q + 1, R, 0, R.Length - 1);

            int[] maxArr = new int[A[0].Dimension()];

            for(int i = 0; i < A[0].Dimension(); i++)
            {
                maxArr[i] = int.MaxValue;
            } 
            
            L[n1] = new Tuple(maxArr);
            R[n2] = new Tuple(maxArr);
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

        static void ComparableMergeSort(Tuple[] A)
        {
            CMergeSort(A, 0, A.Length-1);
        }
        static void CMergeSort(IComparable[] A, int p, int r)
        {
            if (p < r)
            {
                int q = (p + r) / 2;
                CMergeSort(A, p, q);
                CMergeSort(A, q + 1, r);
                CMerge(A, p, q, r);
            }
        }

        static void CMerge(IComparable[] A, int p, int q, int r)
        {
            int n1 = q - p + 1;
            int n2 = r - q;
            IComparable[] L = new IComparable[n1 + 1];
            IComparable[] R = new IComparable[n2 + 1];
            Array.Copy(A, p, L, 0, L.Length - 1);
            Array.Copy(A, q + 1, R, 0, R.Length - 1);

            if(A[0] is Tuple) {
                int[] maxArr = new int[4];
                for (int i = 0; i < 4; i++)
                    {
                        maxArr[i] = int.MaxValue;
                    }
                L[n1] = new Tuple(maxArr);
                R[n2] = new Tuple(maxArr);
            } else
            {
                L[n1] = int.MaxValue;
                R[n2] = int.MaxValue;
            }

            int n = 0;
            int m = 0;
            for (int k = p; k <= r; k++)
            {
                if (L[n].CompareTo(R[m]) < 0 || L[n].CompareTo(R[m]) == 0)
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

        static void PrintArray<T>(T[] t)
        {
            foreach (T item in t)
            {
                Console.Write($"{item.ToString()}, ");
            }
            Console.WriteLine();
        }

        public delegate int MathOperation(int x, int y);
        public static int SoucetParu(int x, int y)
        {
            return x + y;
        }
        public static int NasobekParu(int x, int y)
        {
            return x * y;
        }

        public static int[] MapMathOperation(int[] array1, int[] array2, MathOperation op)
        {
            int[] res = new int[array1.Length];
            for (int i = 0; i < array1.Length; i++)
            {
                res[i] = op(array1[i], array2[i]);
            }
            return res;
        }


        static void Main(string[] args)
        {
            int[] arr1 = { 7, 6, 1, 3 };
            int[] arr2 = { 4, 3, 1, 2 };
            int[] arr3 = { 4, 3, 1, 3 };

            Tuple[] tuples = { new Tuple(arr1), new Tuple(arr2), new Tuple(arr3)};
            PrintArray(tuples);
            TupleMergeSort(tuples);
            PrintArray(tuples);
            ComparableMergeSort(tuples);
            PrintArray(tuples);

            PrintArray(MapMathOperation(arr1, arr2, SoucetParu));
            PrintArray(MapMathOperation(arr1, arr2, NasobekParu));
        }
    }
}

