#include "stdafx.h"
#include "TelesoSKruhovouPodstavou.h"
#include <cmath>

TelesoSKruhovouPodstavou::TelesoSKruhovouPodstavou(double polomer)
{
	this->polomer = polomer;
}

double TelesoSKruhovouPodstavou::obsah()
{
	double PI = 3.14159265;
	return PI * polomer * polomer;
}

TelesoSKruhovouPodstavou::~TelesoSKruhovouPodstavou()
{
}
