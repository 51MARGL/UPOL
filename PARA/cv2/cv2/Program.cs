using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading;
using System.Threading.Tasks;

namespace cv2
{
    class Program
    {
        private static Tuple<int, int> pair;
        private static int? resultGCD;
        private static int oneCount;
        private static int allCount;

        private static bool exit;

        static void Producent()
        {
            Random rand = new Random();
            int x1 = rand.Next(1, 1001);
            int x2 = rand.Next(1, 1001);
            pair = new Tuple<int, int>(x1, x2);
            while (!exit)
            {
                x1 = rand.Next(1, 1001);
                x2 = rand.Next(1, 1001);
                while (pair != null) if (exit) return;
                pair = new Tuple<int, int>(x1, x2);
            }
        }

        private static void ProdCons()
        {
            while (!exit)
            {
                while ( pair == null || resultGCD != null) if (exit) return;
                resultGCD = GCD(pair.Item1, pair.Item2) > 1 ? 1 : 0;
                pair = null;
            }
        }

        private static void Consument()
        {
            while (number > oneCount)
            {
                while (resultGCD == null) ;
                if (resultGCD == 1)
                    oneCount++;
                allCount++;
                resultGCD = null;
            }
            exit = true;
        }

        private static int GCD(int a, int b)
        {
            while (a != 0 && b != 0)
            {
                if (a > b)
                    a %= b;
                else
                    b %= a;
            }

            return a == 0 ? b : a;
        }

        private static int number;
        static void Main(string[] args)
        {
            Console.Write("Enter number: ");
            number = int.Parse(Console.ReadLine());
            var threadList = new List<Thread> { new Thread(Producent), new Thread(ProdCons), new Thread(Consument) };

            threadList.ForEach(t => t.Start());
            threadList.ForEach(t => t.Join());
            Console.WriteLine("All count = " + allCount);
            Console.WriteLine("Ones count = " + oneCount);
            Console.WriteLine("Division = " + (float)oneCount / allCount);

            Console.ReadLine();
        }
    }
}
