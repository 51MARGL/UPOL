#pragma once
#include "TelesoSKruhovouPodstavou.h"
class Valec : public TelesoSKruhovouPodstavou
{
public:
	Valec(double vyska, double polomer);
	double objem();
	~Valec();
};

