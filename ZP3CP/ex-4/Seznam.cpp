#include "stdafx.h"
#include "Seznam.h"
#include <iostream>
using namespace std;


Seznam *Seznam::prvni = nullptr;
Seznam *Seznam::iterator = prvni;

Seznam::Seznam(){}

Seznam::Seznam(int a) : cislo(a) { 
}

int Seznam::prvek() const 
{
	return cislo;
}

bool Seznam::nastavitNaPrvni()
{
	iterator = prvni;
	return true;
}

Seznam * Seznam::aktualni()
{

	return iterator;
}

bool Seznam::posunoutNaDalsi()
{
	if (iterator != nullptr) {
		iterator = prvni->dalsi;
		return true;
	}
	else return false;
}

Seznam::~Seznam()
{
}

