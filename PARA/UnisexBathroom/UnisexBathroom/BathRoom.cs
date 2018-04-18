using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading;
using System.Threading.Tasks;

namespace UnisexBathroom.Users
{
    class Bathroom
    {
        private int bathSize;
        private int menCount;
        private int womenCount;
        private int waitMenCount;
        private int waitWomenCount;

        private Semaphore menSemaphore;
        private Semaphore womenSemaphore;
        private Semaphore bathroomSemaphore;

        //Fair queue. FIFO, but need to wait till bathroom is empty
        private Queue<Person> personsInFront;

        public int BathSize
        {
            get => bathSize;
            set => bathSize = value;
        }

        public Bathroom(int size)
        {
            bathSize = size;

            //first param - initial value, second param - maximum value
            menSemaphore = new Semaphore(0, BathSize);
            womenSemaphore = new Semaphore(0, BathSize);
            bathroomSemaphore = new Semaphore(1, 1);
            personsInFront = new Queue<Person>();
        }

        public void Enter(Person person)
        {
            try
            {                
                if (person is Man)
                {
                    bathroomSemaphore.WaitOne();
                    personsInFront.Enqueue(person);
                    if (womenCount > 0  || menCount == BathSize)
                    {
                        waitMenCount++;
                        bathroomSemaphore.Release();
                        menSemaphore.WaitOne();
                    }

                    personsInFront = new Queue<Person>(personsInFront.Where(p => p != person));
                    menCount++;

                    //debug
                    person.Enter();

                    if (waitMenCount > 0 
                        && menCount < BathSize 
                        && personsInFront.Peek() is Man)
                    {
                        waitMenCount--;
                        menSemaphore.Release();
                    }
                    else
                        bathroomSemaphore.Release();
                }
                else
                {
                    bathroomSemaphore.WaitOne();
                    personsInFront.Enqueue(person);
                    if (menCount > 0 || womenCount == BathSize)
                    {
                        waitWomenCount++;
                        bathroomSemaphore.Release();
                        womenSemaphore.WaitOne();
                    }

                    personsInFront = new Queue<Person>(personsInFront.Where(p => p != person));
                    womenCount++;

                    //debug
                    person.Enter();

                    if (waitWomenCount > 0 
                        && womenCount < BathSize 
                        && personsInFront.Peek() is Woman)
                    {
                        waitWomenCount--;
                        womenSemaphore.Release();
                    }
                    else
                        bathroomSemaphore.Release();
                }                
            }
            catch (Exception e)
            {
                Console.WriteLine(e.Message);        
            }
        }

        public void Leave(Person person)
        {
            try
            {
                if (person is Man)
                {
                    bathroomSemaphore.WaitOne();
                    menCount--;

                    //debug
                    person.Exit();

                    if (waitMenCount > 0 
                        && menCount < BathSize 
                        && personsInFront.Peek() is Man)
                    {
                        waitMenCount--;
                        menSemaphore.Release();
                    }
                    else if (menCount == 0 && waitWomenCount > 0)
                    {
                        waitWomenCount--;
                        womenSemaphore.Release();
                    }
                    else
                        bathroomSemaphore.Release();
                }
                else
                {
                    bathroomSemaphore.WaitOne();
                    womenCount--;

                    //debug
                    person.Exit();

                    if (waitWomenCount > 0 
                        && womenCount < BathSize
                        && personsInFront.Peek() is Woman)
                    {
                        waitWomenCount--;
                        womenSemaphore.Release();
                    }
                    else if (womenCount == 0 && waitMenCount > 0)
                    {
                        waitMenCount--;
                        menSemaphore.Release();
                    }
                    else
                        bathroomSemaphore.Release();
                }                
            }
            catch (Exception e)
            {
                Console.WriteLine(e.Message);           
            }
        }
    }
}
