// ConsoleApplication6.cpp : Defines the entry point for the console application.
//

#include "stdafx.h"
#include <iostream>
#include "Seznam.h"
using namespace std;


int main()
{
	Seznam *s = new Seznam(1);
	cout << s->prvek() << endl;
	s->nastavitNaPrvni();
	s = new Seznam(5);
	cout << s->prvek() << endl;
	cout << s->posunoutNaDalsi() << endl;;

    return 0;
}

