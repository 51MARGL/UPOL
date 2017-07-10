#pragma once
#include "Cm.h"
class Palec
{
	double p;
public:
	Palec(double p);
	~Palec();

	double hodnota();
	double cm();
	double rozdil(Palec &);
	double rozdil(class Cm &);
};

