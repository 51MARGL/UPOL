// drawdll.cpp : Defines the exported functions for the DLL application.
//

#include "stdafx.h"
#include <iostream>
using namespace std;

#define DLL __declspec(dllexport)

DLL void ctverec(int delka, char strana, char vnitr) {
	for (int i = 0; i < delka; i++)
	{
		for (int j = 0; j < delka; j++)
		{
			if (i == 0 || i == delka - 1 || j == 0 || j == delka - 1)
				cout << strana;
			else
				cout << vnitr;
		}
		cout << endl;
	}
}

DLL void mriz(int delka, int horizontal, int vertical, char znak) {

	int raws = delka * vertical;
	int columns = delka * horizontal;
	for (int i = 0; i <= raws; i++)
	{
		for (int j = 0; j <= columns; j++)
		{
			if (i == 0 || i % delka == 0 || j % delka == 0 || i == raws || j == columns)
				cout << znak;
			else
				cout << " ";
		}
		cout << endl;
	}
}
