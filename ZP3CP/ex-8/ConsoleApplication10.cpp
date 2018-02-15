// ConsoleApplication10.cpp : Defines the entry point for the console application.
//

#include "stdafx.h"
#include "Fronta.h"
#include <iostream>
using namespace std;


int main()
{
	Fronta f(5);
	f << 5 << 8 << 2 << 6 << 3;
	int a, b;
	f >> a >> b;
	cout << a << " " << b << endl;
	f();
	f << 4 << 7;
	cout << +f << endl;
	f();
	f << 10;
    return 0;
}

