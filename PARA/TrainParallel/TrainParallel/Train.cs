using System;
using System.Collections.Generic;
using System.Text;
using System.Threading;

namespace TrainParallel
{
    class Train
    {
        public int Capacity { get; set; }
        private const int TravelTime = 5000;

        public Semaphore TrainLoadSem;
        public Semaphore TrainUnLoadSem;
        public Semaphore TravelSemaphore;
        public int PassengersInside;

        public Train(int capacity)
        {
            this.Capacity = capacity;
            TrainLoadSem = new Semaphore(0, this.Capacity);
            TrainUnLoadSem = new Semaphore(0, this.Capacity);
            TravelSemaphore = new Semaphore(0, 1);
        }

        public void Load()
        {
            Console.WriteLine(">Train is loading people");
            TrainLoadSem.Release(this.Capacity);
            TravelSemaphore.WaitOne();
        }

        public void Travel()
        {
            Console.WriteLine("---Train is traveling");
            Thread.Sleep(TravelTime);
        }

        public void UnLoad()
        {
            Console.WriteLine("<Train is unloading people");
            TrainUnLoadSem.Release(this.Capacity);
            TravelSemaphore.WaitOne();
        }
    }
}
