#pragma once
class Fronta
{
	Fronta *next;
	int *fronta;
	int pocet;
	int velikost;
public:
	Fronta(unsigned);
	Fronta & operator << (int);
	Fronta & operator >> (int &);
	int & operator + ();
	void operator () ();
	~Fronta();
};

