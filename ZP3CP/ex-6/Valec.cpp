#include "stdafx.h"
#include "Valec.h"


Valec::Valec(double vyska, double polomer) : Teleso(vyska), TelesoSKruhovouPodstavou(polomer)
{
}

double Valec::objem() {
	return obsah() * vyska;
}

Valec::~Valec()
{
}
