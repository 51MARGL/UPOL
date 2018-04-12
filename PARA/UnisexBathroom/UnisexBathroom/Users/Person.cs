using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading;
using System.Threading.Tasks;

namespace UnisexBathroom.Users
{
    abstract class Person
    {
        protected Bathroom bathroom;
        protected int number;
        public abstract string Gender { get; }

        protected Person(int number, Bathroom bathroom)
        {
            this.number = number;
            this.bathroom = bathroom;
        }

        public virtual void Enter()
        {
            Console.WriteLine($"=> {Gender} #{number} Enters the bathroom");
        }

        public virtual void DoStuff(int minTime, int maxTime)
        {
            var rnd = new Random();
            Thread.Sleep(rnd.Next(minTime, maxTime));
        }

        public virtual void Exit()
        {
            Console.WriteLine($"<= {Gender} #{number} Exits the bathroom");
        }

        public abstract void GoToBathRoom();
    }
}
