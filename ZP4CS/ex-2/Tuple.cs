using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ConsoleApplication13
{
    class Tuple : IComparable
    {
        private int[] t { get; set; } 

        public int Dimension()
        {
            return t.Length;
        }
        public Tuple(int[] arr)
        {
            t = arr;
        }

        public static bool operator ==(Tuple t1, Tuple t2)
        {
            for(int i = 0; i < t1.Dimension(); i++)
            {
                if (t1.t[i] != t2.t[i]) return false;
            }
            return true;
        }

        public static bool operator !=(Tuple t1, Tuple t2)
        {
            for (int i = 0; i < t1.Dimension(); i++)
            {
                if (t1.t[i] != t2.t[i]) return true;
            }
            return false;
        }

        public static bool operator >(Tuple t1, Tuple t2)
        {
            for (int i = 0; i < t1.Dimension(); i++)
            {
                if (t1.t[i] > t2.t[i]) return true;
                else if (t1.t[i] < t2.t[i]) return false;
            }
            return false;
        }

        public static bool operator <(Tuple t1, Tuple t2)
        {
            for (int i = 0; i < t1.Dimension(); i++)
            {
                if (t1.t[i] < t2.t[i]) return true;
                else if (t1.t[i] > t2.t[i]) return false;
            }
            return false;
        }

        public static bool operator >=(Tuple t1, Tuple t2)
        {
            for (int i = 0; i < t1.Dimension(); i++)
            {
                if (t1.t[i] > t2.t[i]) return true;
                else if (t1.t[i] < t2.t[i]) return false;
            }
            return true;
        }

        public static bool operator <=(Tuple t1, Tuple t2)
        {
            for (int i = 0; i < t1.Dimension(); i++)
            {
                if (t1.t[i] < t2.t[i]) return true;
                else if (t1.t[i] > t2.t[i]) return false;
            }
            return true;
        }

        public override string ToString()
        {
            String str = "<";
            foreach (int item in t)
            {
                str += $"{item}, ";
            }
            return str += ">";
        }

        public int CompareTo(object obj)
        {
            if (obj is Tuple)
            {
                if ((Tuple)obj == this) return 0;
                else if ((Tuple)obj < this) return 1;
                else return -1;
            } else
            {
                throw new Exception("Not Tuple");
            }
        }
    }
}
