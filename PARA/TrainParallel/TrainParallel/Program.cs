using System;
using System.Collections.Generic;
using System.Threading;

namespace TrainParallel
{
    class Program
    {
        static void Main(string[] args)
        {
            try
            {
                var trainCapacity = 5;
                var passengersCount = 25;
                // "Vozidlo vyjede na horskou dráhu pouze pokud je plné." - if passengersCount % capacity != 0 - deadlock
                if (passengersCount % trainCapacity != 0)
                    throw new Exception("To avoid deadlock passengersCount must be divideble by train Capacity.");
                var train = new Train(trainCapacity);
                var threadList = new List<Thread>();

                var rnd = new Random();
                for (int i = 0; i < passengersCount; i++)
                    threadList.Add(new Thread(new Person(i, train, rnd).TakeARide));


                threadList.ForEach(t => t.Start());

                while (passengersCount > 0)
                {
                    train.Load();
                    train.Travel();
                    train.UnLoad();
                    passengersCount -= train.Capacity;
                }

                threadList.ForEach(t => t.Join());

                Console.WriteLine("\n\nDone.");
                Console.ReadLine();
            }
            catch (Exception ex)
            {
                Console.WriteLine("Error occured: " + ex.Message + "\nDeatils:\n" + ex.StackTrace);
            }
        }
    }
}