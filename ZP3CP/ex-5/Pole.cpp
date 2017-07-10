#include "stdafx.h"
#include "Pole.h"


Pole::Pole(unsigned a) : n(a)
{
	this->pole = new int(a);
	this->pocet = 0;
}


Pole::~Pole()
{
	delete[] pole;
}

bool Pole::pridat(int a)
{
	if (pocet >= n) return false;
	for (int i = 0; i < pocet; i++) {
		if (a == pole[i]) return false;
	}
	pole[pocet] = a;
	pocet++;
	return true;
}


void vypsat(const Pole &pole) {
	for (int i = 0; i < pole.pocet; i++) {
		cout << pole.pole[i] << ", ";
	}
	cout << endl;
}

bool zrusit(Pole &pole, int a) {
	for (int i = 0; i <= pole.pocet; i++) {
		if (a == pole.pole[i]) {
			for (int j = i; j < pole.pocet - 1 ; j++) {
				pole.pole[j] = pole.pole[j + 1];
			}
			pole.pocet--;
			return true;
		}
	}
	return false;
}