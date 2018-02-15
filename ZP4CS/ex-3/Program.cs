using System;
using System.Diagnostics;

namespace cv_3
{
    class Program
    {

        public static void ParalelMergeSort(int[] o, int depth)
        {
            PMerge m = new PMerge();
            m.ParalMergeSort(o, 0, o.Length - 1, depth);
        }

        public static void PrintArray<T>(T[] t)
        {
            foreach (T item in t)
            {
                Console.Write($"{item.ToString()}, ");
            }
            Console.WriteLine();
        }

        public static int[] GetRandomArray(int v)
        {
            Random r = new Random();
            int[] arr = new int[v];
            for (int i = 0; i < v; i++)
            {
                arr[i] = r.Next(0, 10000);
            }
            return arr;
        }

        public static bool IsSorted(int[] arr)
        {
            for (int i = 0; i < arr.Length - 1; i++)
            {
                if (arr[i] > arr[i + 1])
                {
                    return false;
                }
            }
            return true;
        }
        static void Main(string[] args)
        {
            int[] arr1 = GetRandomArray(10000000);
            int[] arr2 = new int[arr1.Length];
            int[] arr3 = new int[arr1.Length];
            Array.Copy(arr1, arr2, arr1.Length);
            Array.Copy(arr1, arr3, arr1.Length);

            Stopwatch sw = Stopwatch.StartNew();
            ParalelMergeSort(arr1, 0);
            sw.Stop();
            Console.WriteLine("0 threads: {0}ms; Is Sorted? - {1}", sw.Elapsed.TotalMilliseconds, IsSorted(arr1));

            sw = Stopwatch.StartNew();
            ParalelMergeSort(arr2, 1);
            sw.Stop();
            Console.WriteLine("1 thread: {0}ms; Is Sorted? - {1}", sw.Elapsed.TotalMilliseconds, IsSorted(arr2));

            sw = Stopwatch.StartNew();
            ParalelMergeSort(arr3, 2);
            sw.Stop();
            Console.WriteLine("2 threads: {0}ms; Is Sorted? - {1}", sw.Elapsed.TotalMilliseconds, IsSorted(arr3));
            Console.WriteLine("End");
            Console.ReadLine();
        }
    }
}
