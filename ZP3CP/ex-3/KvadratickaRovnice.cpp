#include "stdafx.h"
#include "KvadratickaRovnice.h"
#include <iostream>
#include <cmath>
using namespace std;

KvadratickaRovnice::KvadratickaRovnice(int a, int b, int c)
{
	this->a = a;
	this->b = b;
	this->c = c;
}


KvadratickaRovnice::~KvadratickaRovnice()
{
}

int KvadratickaRovnice::diskriminant()
{
	return (this->b * this->b - 4 * this->a * this->c);
}


int KvadratickaRovnice::pocetKorenu()
{
	int d = diskriminant();
	if (d == 0) return 1;
	else if (d > 0) return 2;
	else return 0;
}

int KvadratickaRovnice::koren1()
{
	if (pocetKorenu() == 0 || pocetKorenu() == 2) {
		return (-this->b + sqrt(diskriminant())) / 2 * this->a;
	}
	else {
		cout << "Koreny nejsou" << endl;
	}
}

int KvadratickaRovnice::koren2()
{
	if (pocetKorenu() == 2) {
		return (-this->b - sqrt(diskriminant())) / 2 * this->a;
	}
}
