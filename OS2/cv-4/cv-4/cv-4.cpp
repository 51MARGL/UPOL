// cv-4.cpp : Defines the entry point for the console application.
//

#include "stdafx.h"
#include <windows.h>
#include <iostream>
#include <assert.h>
#include <string>
#include <fstream>
using namespace std;

struct Param {
	const char *soubor, *filtr;
};

DWORD WINAPI hledat(CONST LPVOID lpParam) {
	int resultCount = 0;
	Param arg = *((Param*)lpParam);
	string fileName = arg.soubor;
	ifstream file("..\\" + fileName);
	string str;
	while (getline(file, str))
	{
		string lowStr;
		string lowFiltr;
		string filtr(arg.filtr);
		for (int i = 0; i < str.length(); ++i)
			lowStr += tolower(str[i]);
		for (int i = 0; i < filtr.length(); ++i)
			lowFiltr += tolower(filtr[i]);
		if (lowStr.find(lowFiltr) == 0) {
			resultCount++;
		}
	}
	ExitThread(resultCount);
}


int main() {
	HANDLE hThreads[2];

	char Filtr[30];
	cout << "Enter filter" << endl;
	cin >> Filtr;
	Param arg1 = { "Jmena1",Filtr };
	Param arg2 = { "Jmena2",Filtr };

	hThreads[0] = CreateThread(NULL, 0, &hledat, &arg1, 0, NULL);
	if (NULL == hThreads[0]) {
		cout << "Error in Thread creation" << endl;
	}
	hThreads[1] = CreateThread(NULL, 0, &hledat, &arg2, 0, NULL);
	if (NULL == hThreads[1]) {
		cout << "Error in Thread creation" << endl;
	}

	WaitForMultipleObjects(2, hThreads, TRUE, INFINITE);

	assert(hThreads[0] && hThreads[1]);

	DWORD res1;
	GetExitCodeThread(hThreads[0], &res1);
	DWORD res2;
	GetExitCodeThread(hThreads[1], &res2);
	cout << "Thread1 result: " << res1 << endl;
	cout << "Thread2 result: " <<  res2 << endl;

	CloseHandle(hThreads[0]);
	CloseHandle(hThreads[1]);

	char x;
	cin >> x;
	ExitProcess(0);
}
