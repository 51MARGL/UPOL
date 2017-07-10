#pragma once
#include "Teleso.h"
class Kvadr : public Teleso
{
public:
	double a, b;
	Kvadr(double, double, double);
	double objem();
	~Kvadr();
};

