using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace UnisexBathroom.Users
{
    class Woman : Person
    {
        public override string Gender { get; } = "Woman";

        public Woman(int number, Bathroom bathroom) : base(number, bathroom) { }

        public override void GoToBathRoom()
        {
            bathroom.Enter(this);
            base.DoStuff(1000, 2000);
            bathroom.Leave(this);
        }
    }
}
