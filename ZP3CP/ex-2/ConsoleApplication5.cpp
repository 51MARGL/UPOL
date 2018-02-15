// ConsoleApplication5.cpp : Defines the entry point for the console application.
//

#include "stdafx.h"
#include <iostream>
#include "Cm.h"
#include "Palec.h"
using namespace std;


int main()
{
	Cm *a1 = new Cm(10);
	Cm *a2 = new Cm(20);
	Palec *p1 = new Palec(5);
	Palec *p2 = new Palec(8);

	cout << "a1=" << a1->hodnota()<<"cm"<< endl;
	cout << "a2=" << a2->hodnota()<<"cm"<< endl;
	cout << "p1=" << p1->hodnota()<<"p"<< endl;
	cout << "p2=" << p2->hodnota()<<"p" << endl;

	cout << "a1=" << a1->palec() << "p" << endl;
	cout << "a2=" << a2->palec() << "p" << endl;
	cout << "p1=" << p1->cm() << "cm" << endl;
	cout << "p2=" << p2->cm() << "cm" << endl;

	cout << "Rozdil a1 a a2 =" << a1->rozdil(*a2) << endl;
	cout << "Rozdil p1 a p2 =" << p1->rozdil(*p2) << endl;
	cout << "Rozdil a1 a p1 =" << a1->rozdil(*p1) << endl;
	cout << "Rozdil p2 a a2 =" << p2->rozdil(*a2) << endl;
    return 0;
}

