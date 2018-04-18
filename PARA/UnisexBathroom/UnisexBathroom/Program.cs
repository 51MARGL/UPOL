using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading;
using System.Threading.Tasks;
using UnisexBathroom.Users;

namespace UnisexBathroom
{
    public class Program
    {
        static void Main(string[] args)
        {
            try
            {
                Bathroom bathroom = new Bathroom(3);
                Random rnd = new Random();
                var personCount = rnd.Next(25, 50);
                var threadList = new List<Thread>();
                for (var i = 0; i < personCount; i++)
                    threadList.Add(rnd.Next(100) < 50
                        ? new Thread(new Man(i, bathroom).GoToBathRoom)
                        : new Thread(new Woman(i, bathroom).GoToBathRoom));
                threadList.ForEach(t => t.Start());
                threadList.ForEach(t => t.Join());

                Console.WriteLine();
                Console.WriteLine();

                threadList = new List<Thread>();
                for (var i = 0; i < 15; i++)
                    threadList.Add(new Thread(new Man(i, bathroom).GoToBathRoom));
                threadList.Add(new Thread(new Woman(15, bathroom).GoToBathRoom));
                for (var i = 16; i < 31; i++)
                    threadList.Add(new Thread(new Man(i, bathroom).GoToBathRoom));
                threadList.ForEach(t => t.Start());
                threadList.ForEach(t => t.Join());

                Console.WriteLine("Done");
                Console.ReadLine();
            }
            catch (Exception e)
            {
                Console.WriteLine("Error stack: " + e.StackTrace);              
            }
        }
    }
}
