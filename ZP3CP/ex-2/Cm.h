#pragma once
#include "Palec.h"
class Cm
{
	double cm;
public:
	Cm(double a);
	~Cm();

	double hodnota() { return this->cm; }
	double palec();
	double rozdil(Cm &);
	double rozdil(class Palec &);
};

