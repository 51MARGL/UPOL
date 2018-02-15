// ConsoleApplication11.cpp : Defines the entry point for the console application.
//

#include "stdafx.h"
#include "Zlomek.h"
#include <iostream>

using namespace std;

Zlomek operator / (unsigned i, const Zlomek &z)
{
	return Zlomek(i*z.jm(), 1*z.cit());
}

Zlomek operator + (unsigned i, const Zlomek &z)
{
	return Zlomek(i*z.jm() + z.cit()*1, 1*z.jm());
}

Zlomek operator - (unsigned i, const Zlomek &z)
{
	return Zlomek(i*z.jm() - z.cit() * 1, 1 * z.jm());
}

Zlomek operator * (unsigned i, const Zlomek &z)
{
	return Zlomek(i*z.cit(), 1 * z.jm());
}

int main()
{
	Zlomek a(1, 2), b(1,3);
	Zlomek &z = (a - b + 1u)* 5u/(2u + Zlomek(2, 3));
	z();
	Zlomek &k = Zlomek(3, 2) - Zlomek(1, 8);
	k();
	cout << +k << endl;

	Zlomek &x = (a - b);
	Zlomek &y = 2u * Zlomek(1, 12);
	x();
	y();
	bool t = x == y;
	cout << t << endl;
	(2u / a)();
    return 0;
}

