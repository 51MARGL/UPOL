#include "stdafx.h"
#include "Kuzel.h"


Kuzel::Kuzel(double vyska, double polomer) : Teleso(vyska), TelesoSKruhovouPodstavou(polomer)
{
}

double Kuzel::objem() {
	return obsah() * vyska / 3;
}

Kuzel::~Kuzel()
{
}
