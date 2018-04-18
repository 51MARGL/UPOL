using System;
using System.Collections.Generic;
using System.Text;
using System.Threading;

namespace TrainParallel
{
    class Person
    {
        public int Id { get; set; }
        public Train Train;
        public Semaphore Mutex;

        private Random pseudoRand;
        public Person(int id, Train train, Random random)
        {
            this.Id = id;
            this.Train = train;
            this.pseudoRand = random;
            Mutex = new Semaphore(1, 1);
        }

        //Most important here
        public void TakeARide()
        {
            Train.TrainLoadSem.WaitOne();
            Board();

            Mutex.WaitOne();
            //Board(); if placed here instead will cause one by one entering (not Roller coaster case)

            Train.PassengersInside++;
            if (Train.PassengersInside == Train.Capacity)
                Train.TravelSemaphore.Release();
            Mutex.Release();

            Train.TrainUnLoadSem.WaitOne();
            UnBoard();

            Mutex.WaitOne();
            Train.PassengersInside--;
            if (Train.PassengersInside == 0)
                Train.TravelSemaphore.Release();
            Mutex.Release();
        }

        public void Board()
        {
            Thread.Sleep(pseudoRand.Next(2500, 5000));
            Console.WriteLine($"=> Person #{Id} entered the train");
        }

        public void UnBoard()
        {
            Thread.Sleep(pseudoRand.Next(2500, 5000));
            Console.WriteLine($"<= Person #{Id} left the train");
        }
    }
}
