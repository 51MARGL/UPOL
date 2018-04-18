using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Threading;

namespace cv3
{
    class Program
    {
        private static bool[] boolArray;
        private static int[] randomtArray;
        private static int[] resultArray;
        private static int[] old;
        private static Barrier barrier;

        private static void BoolCount(int i, int n)
        {            
            var d = 1;
            resultArray[i] = boolArray[i] == true ? 1 : 0;
            barrier.SignalAndWait();
            while (d < n)
            {
                old[i] = resultArray[i];
                barrier.SignalAndWait();
                if (i - d >= 0)
                {
                    resultArray[i] += old[i - d];
                }
                barrier.SignalAndWait();
                d *= 2;
            }
        }

        private static void ParallelSort(int i, int n)
        {
            var d = 1;
            var lap = 0;
            resultArray[i] = randomtArray[i];
            barrier.SignalAndWait();
            while (lap < n)
            {
                old[i] = resultArray[i];
                barrier.SignalAndWait();
                if (lap % 2 == 0)
                {
                    if (i % 2 == 0 && (i + 1 < n) && old[i] > old[i + 1])
                    {
                        resultArray[i] = old[i + 1];
                        resultArray[i + 1] = old[i];
                    } 
                }
                else
                {
                    if (i % 2 != 0 && (i + 1 < n) && old[i] > old[i + 1])
                    {
                        resultArray[i] = old[i + 1];
                        resultArray[i + 1] = old[i];
                    }
                }
                barrier.SignalAndWait();
                lap++;
            }
        }

        static void Main(string[] args)
        {
            Console.Write("Enter n: ");
            int n = int.Parse(Console.ReadLine());

            barrier = new Barrier(n);
            boolArray = new bool[n];
            resultArray = new int[n];
            randomtArray = new int[n];
            old = new int[n];

            var rnd = new Random();
            for (int i = 0; i < n; i++)
            {
                boolArray[i] = rnd.Next(0, 100) < 50 ? true : false;
            }


            var threads = new List<Thread>();
            for (int i = 0; i < n; i++)
            {
                var index = i;
                threads.Add(new Thread(() =>
                {
                    BoolCount(index, n);
                }));
            }

            threads.ForEach(t => t.Start());
            threads.ForEach(t => t.Join());

            Console.WriteLine("Result: " + resultArray[n - 1]);
            Console.WriteLine("ActualResult: " + boolArray.Count(i => i == true));
            foreach (var b in boolArray)
            {
                Console.Write(b + " ");
            }

            Console.WriteLine();
            Console.WriteLine();

            //2
            for (int i = 0; i < n; i++)
            {
                randomtArray[i] = rnd.Next(0, 100);
            }
            threads = new List<Thread>();
            for (int i = 0; i < n; i++)
            {
                var index = i;
                threads.Add(new Thread(() =>
                {
                    ParallelSort(index, n);
                }));
            }

            threads.ForEach(t => t.Start());
            threads.ForEach(t => t.Join());

            Console.WriteLine("Unsorted: ");
            foreach (var item in randomtArray)
            {
                Console.Write(item + " ");
            }
            Console.WriteLine();

            Console.WriteLine("Result: "); 
            foreach (var item in resultArray)
            {
                Console.Write(item + " ");
            }

            Console.ReadLine();
        }
    }
}
