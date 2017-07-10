#include "stdafx.h"
#include "Fronta.h"
#include <iostream>
using namespace std;


Fronta::Fronta(unsigned n)
{
	fronta = new int[n + 1];
	velikost = n;
	pocet = 0;
	next = NULL;
}

Fronta & Fronta::operator<<(int x)
{
	if (pocet < velikost) {
		fronta[pocet] = x;
		pocet++;
		return *this;
	}
	else {
		cout << "Error. Too much args" << endl;
		return *this;
	}

}

Fronta & Fronta::operator >> (int &x)
{
	if (pocet != 0) {
		x = fronta[0];
		for (int i = 0; i < pocet-1; i++) {
			fronta[i] = fronta[i + 1];
		}
		pocet--;
		return *this;
	}
	else {
		cout << "Error. Is Empty" << endl;
		return *this;
	}
}

int & Fronta::operator+()
{
	return pocet;
}

void Fronta::operator()()
{
	for (int i = 0; i < pocet; i++) {
		cout << fronta[i] << " ";
	}
	cout << endl;
}

Fronta::~Fronta()
{
	delete[] fronta;
}
