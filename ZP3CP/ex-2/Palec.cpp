#include "stdafx.h"
#include "Palec.h"
#include <cmath>


Palec::Palec(double p)
{
	this->p = p;
}


Palec::~Palec()
{
}

double Palec::hodnota()
{
	return this->p;
}

double Palec::cm()
{
	return p * 2.54;
}

double Palec::rozdil(Palec & p)
{
	return abs(this->p - p.hodnota());
}

double Palec::rozdil(Cm & a)
{
	return abs(this->p - a.palec());
}
