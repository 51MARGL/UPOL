using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading;
using System.Threading.Tasks;
using System.Linq;
using System.Linq.Expressions;

namespace cv1
{
    class Program
    {
        private static int counter;
        private static object lockKey;
        private static void Increment(int n)
        {
            for (int i = 0; i < n; i++)
            {
                // lock (lockKey)
                // {
                counter++;
                // } 
            }
        }

        private static void SleepMe(Random rand)
        {
            var time = rand.Next(0, 5000);
            Thread.Sleep(time);
            Console.WriteLine("I was sleeping for: " + (double)time / 1000 + " s");
        }

        static int[] C = { 11, 22, 3, 42, 15, 6, 73, 85, 91, 10 };
        static int[] D = new int[10];

        private static void ConcA(int i)
        {
            var myNumber = C[i];
            var count = C.Count(c => c < myNumber);
            D[count] = myNumber;
        }

        static void Main(string[] args)
        {
            lockKey = new object();
            counter = 0;
            int n = 100000;
            Console.WriteLine("Counter increment:");
            Parallel.Invoke(
                () => Increment(n),
                () => Increment(n)
                );
            Console.WriteLine("Counter = " + counter);

            Console.WriteLine("Thread sleeping:");
            var rand = new Random();
            var t1 = Task.Run(() => SleepMe(rand));
            var t2 = Task.Run(() => SleepMe(rand));
            Task.WaitAll(t1, t2);

            Console.WriteLine("Conc alg A:");
            var taskList = new List<Thread>();
            for (var i = 0; i < 10; i++)
            {
                int index = i;
                var t = new Thread(() => ConcA(index));
                t.Start();
                taskList.Add(t);
            }
            taskList.ForEach(t => t.Join());
            Console.WriteLine("D:");
            foreach (var i in D)
            {
                Console.Write(i + " ");
            }
            Console.ReadLine();
        }
    }
}
