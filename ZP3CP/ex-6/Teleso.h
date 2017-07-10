#pragma once
class Teleso
{
public:
	double vyska;
	Teleso(double vyska);
	virtual double objem() = 0;
	~Teleso();
};

