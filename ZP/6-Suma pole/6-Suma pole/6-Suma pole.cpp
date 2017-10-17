// 6-Suma pole.cpp : Defines the entry point for the console application.
//

#include "stdafx.h"
#include <windows.h>

double suma_pole(double pole[], int pocet)
{
	double suma = 0;
	for (int i = 0; i < pocet; i++)
	{
		suma+=pole[i];
	}
	return suma;
}
int main()
{
	const int size=10;
	double pole[size];
	for (int i = 0; i < size; i++)
	{
		pole[i] = i+1;
	}
	printf("Pole obsahuje cisla:");
	for (int i = 0; i < size; i++)
	{
		printf("%.0lf ",pole[i]);
	}
	printf("\nSuma pole je:%.0lf\n", suma_pole(pole,size));
	system("pause");
    return 0;
}

