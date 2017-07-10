#pragma once
#include <iostream>
using namespace std;
class Pole
{
	int *pole;
	const unsigned n;
	unsigned pocet;
public:
	Pole(unsigned);
	~Pole();
	bool pridat(int);
	friend void vypsat(const Pole &);
	friend bool zrusit(Pole &, int);
};
