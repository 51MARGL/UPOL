#pragma once
#include "Teleso.h"
class TelesoSKruhovouPodstavou : virtual public Teleso
{
public:
	double polomer;
	TelesoSKruhovouPodstavou(double polomer);
	double obsah();
	~TelesoSKruhovouPodstavou();
};

