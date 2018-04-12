using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace UnisexBathroom.Users
{
    class Man : Person
    {
        public override string Gender { get; } = "Man";

        public Man(int number, Bathroom bathroom) : base(number, bathroom) { }       

        public override void GoToBathRoom()
        {
            bathroom.Enter(this);
            base.DoStuff(500, 1000);
            bathroom.Leave(this);
        }
    }
}
