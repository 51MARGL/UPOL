#include "stdafx.h"
#include "KO.h"
#include <cmath>
#include <iostream>
using namespace std;


KO::KO(unsigned const k) : h(k)
{
	this->p = 8;
}

KO & KO::operator=(unsigned k)
{
	unsigned *t = (unsigned*)(&h);
	*t = k % p;
	return *this;
}

KO & KO::operator=(KO &n)
{
	unsigned *t = (unsigned*)(&h);
	*t = n.h % p;
	return *this;
}

KO & KO::operator+=(KO &n)
{
	unsigned *t = (unsigned*)(&h);
	*t = (h + n.h) % p;
	return *this;
}

KO & KO::operator+=(unsigned x)
{
	unsigned *t = (unsigned*)(&h);
	*t = (h + x) % p;
	return *this;
}

KO & KO::operator*=(KO &n)
{
	unsigned *t = (unsigned*)(&h);
	*t = (h * n.h) % p;
	return *this;
}

KO & KO::operator*=(unsigned x)
{
	unsigned *t = (unsigned*)(&h);
	*t = (h * x) % p;
	return *this;
}

bool & KO::operator!() 
{
	bool t = true;
	bool f = false;
	if (!h) return t;
	else return f;
}

bool & KO::operator==(KO &n)
{
	bool t = true;
	bool f = false;
	if (h == n.h) return t;
	else return f;
}

bool & KO::operator==(unsigned x)
{
	bool t = true;
	bool f = false;
	if (h == x) return t;
	else return f;
}

bool & KO::operator!=(KO &n)
{
	bool t = true;
	bool f = false;
	if (h == n.h) return f;
	else return t;
}

bool & KO::operator!=(unsigned x)
{
	bool t = true;
	bool f = false;
	if (h == x) return f;
	else return t;
}

KO::~KO()
{
}
