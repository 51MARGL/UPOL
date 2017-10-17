// ConsoleApplication10.cpp : Defines the entry point for the console application.
//

#include "stdafx.h"
#include <Windows.h>
#include <string.h>


int main()
{
	const int size = 100;
	
	int mas[size];
	for (int i = 0; i < size; i++)
	{
		mas[i] = i;

	}
	mas[0] = 0;
	mas[1] = 0;
	for (int i = 2; i*i < size; i++)
	{
		if (mas[i] != 0)
		{
			for (int j = i*i; j < size; j += i)
			{
				mas[j] = 0;
			}
		}
	}
	for (int i = 0; i<size; i++)
	{
		if(mas[i]!=0) printf("%d ", mas[i]);
	}
	printf("\n");
	system("pause");
	return 0;
}

