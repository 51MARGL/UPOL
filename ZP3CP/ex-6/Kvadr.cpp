#include "stdafx.h"
#include "Kvadr.h"



Kvadr::Kvadr(double vyska, double a, double b) : Teleso(vyska)
{
	this->a = a;
	this->b = b;
}

double Kvadr::objem() {
	return vyska * a * b;
}

Kvadr::~Kvadr()
{
}
