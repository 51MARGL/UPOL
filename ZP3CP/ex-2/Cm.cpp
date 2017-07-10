#include "stdafx.h"
#include "Cm.h"
#include <cmath>

Cm::Cm(double a)
{
	this->cm = a;
}


Cm::~Cm()
{
}

double Cm::palec()
{
	return this->cm/2.54;
}

double Cm::rozdil(Cm &a)
{
	return abs(this->cm - a.hodnota());
}

double Cm::rozdil(Palec & p)
{
	return abs(this->cm - p.cm());
}
