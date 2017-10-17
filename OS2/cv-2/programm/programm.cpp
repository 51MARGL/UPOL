// programm.cpp : Defines the entry point for the console application.
//

#include "stdafx.h"
#include <iostream>
using namespace std;

#define DLL __declspec(dllimport)

DLL void ctverec(int, char, char);
DLL void mriz(int, int, int, char);

int main()
{
	ctverec(7, '#', ':');
	cout << endl;
	mriz(5, 4, 3, '*');
    return 0;
}

