// ConsoleApplication3.cpp : Defines the entry point for the console application.
//

#include "stdafx.h"
#include <iostream>
#include <Windows.h>
using namespace std;

int main()
{
	cout << "   ";
	for (int i = 0; i < 16; i++)
	{
		cout <<uppercase<<hex<<i<<' ';
	}
	cout <<"\n  ";
	for (int i = 0; i <= 33; i++)
	{
		cout << "-";
	}
	cout << endl;
	for (int i = 32; i < 255; i += 16)
	{
		cout <<hex<<i<<'|';
		for (int j = 0; j < 16; j++)
		{

			cout << (char)(i + j)<<' ';
		}
		cout<<"|\n";

	}
	cout << "  ";
	for (int i = 0; i <= 33; i++)
	{
		cout << '-';
	}
	cout << endl << endl;


	cout << "    ";
	for (int i = 0; i < 10; i++)
	{
		cout << dec << i << ' ';
	}

	cout << "\n   ";
	for (int i = 0; i <= 21; i++)
	{
		cout << "-";
	}
	cout << endl;
	for (int i = 30; i < 256; i += 10)
	{
		if(i < 100) cout <<' '<< i << "|";
		else cout<< i << '|';
		for (int j = 0; j < 10; j++)
		{
			if(i + j > 31 && i + j < 256) cout << (char)(i + j) << ' ';
			else cout << "  ";
		}
		cout << "|\n";
	}
	cout << "   ";
	for (int i = 0; i <= 21; i++)
	{
		cout << "-";
	}
	cout << endl;
	system("pause");
    return 0;
}

