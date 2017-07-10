// ConsoleApplication9.cpp : Defines the entry point for the console application.
//

#include "stdafx.h"
#include "KO.h"
#include <iostream>
using namespace std;

bool operator == (unsigned x, KO &n) {
	bool t = true;
	bool f = false;
	if (n == x) return t;
	else return f;
}
bool operator != (unsigned x, KO &n) {
	bool t = true;
	bool f = false;
	if (n == x) return f;
	else return t;
}
int main()
{
	KO a(5);
	KO b(3);
	cout << (a += b += 4) << endl;
	cout << (a *= b *= 2) << endl;
	cout << boolalpha << (a == 0u) << endl;
	cout << boolalpha << !a << endl;
	cout << b << endl;
	cout << boolalpha << (6u != b) << endl;
    return 0;
}

