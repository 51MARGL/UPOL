using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading;
using System.Threading.Tasks;

namespace cv4
{
    class Program
    {
        private static List<int> stack;
        private static Semaphore mutex;
        private static Semaphore popWait;
        private static int popWaitingCount;

        private static int Pop()
        {
            mutex.WaitOne();
            if (IsEmpty())
            {
                popWaitingCount++;
                Console.WriteLine("Pop waiting");
                mutex.Release();
                popWait.WaitOne();
            }

            var i = stack[0];
            stack.RemoveAt(0);

            Console.WriteLine("<= Popped: " + i);

            if (!IsEmpty() && popWaitingCount > 0)
            {
                popWaitingCount--;
                popWait.Release();
            }
            else
                mutex.Release();


            return i;
        }
        private static void Push(int i)
        {
            mutex.WaitOne();
            stack.Insert(0, i);

            Console.WriteLine("=> Pushed: " + i);

            if (popWaitingCount > 0)
            {
                popWaitingCount--;
                popWait.Release();
            }
            else
                mutex.Release();

        }
        private static bool IsEmpty()
        {
            return stack.Count == 0;
        }

        static void Main(string[] args)
        {
            stack = new List<int>();
            mutex = new Semaphore(1, 1);
            popWait = new Semaphore(0, 1);

            var threadList = new List<Thread>();
            var rnd = new Random();
            for (var i = 0; i < 25; i++)
                if(rnd.Next(0,10) < 5)
                {
                    var i1 = i;
                    threadList.Add(new Thread(t => Push(i1)));
                }
                else
                threadList.Add(new Thread(t => Pop()));
            threadList.ForEach(t => t.Start());
            threadList.ForEach(t => t.Join());

            Console.ReadLine();
        }
    }
}
