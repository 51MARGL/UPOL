// ConsoleApplication7.cpp : Defines the entry point for the console application.
//

#include "stdafx.h"
#include <iostream>
#include "Pole.h"
using namespace std;


int main()
{
	Pole *p = new Pole(10);
	p->pridat(1);
	p->pridat(3);
	p->pridat(5);
	p->pridat(7);
	p->pridat(5);
	p->pridat(2);
	p->pridat(4);
	p->pridat(6);
	vypsat(*p);
	zrusit(*p, 5);
	zrusit(*p, 2);
	vypsat(*p);
	p->pridat(8);
	vypsat(*p);
	zrusit(*p, 8);
	vypsat(*p);
    return 0;
}

