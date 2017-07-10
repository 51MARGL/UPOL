// ConsoleApplication8.cpp : Defines the entry point for the console application.
//

#include "stdafx.h"
#include <iostream>
#include <typeinfo>
#include "Valec.h"
#include "Kuzel.h"
#include "Kvadr.h"
using namespace std;

int main()
{
	Teleso *t[] = { new Kvadr(5, 2, 10), new Valec(5, 3), new Kuzel(5, 3) };
	for (int i = 0; i < 3; i++) {
		cout << typeid(*t[i]).name() << " "
			<< t[i]->objem() << endl;
	}
    return 0;
}

