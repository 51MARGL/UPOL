// cv-3.cpp : Defines the entry point for the console application.
//

#include "stdafx.h"
#include <Windows.h>
#include <iostream>
using namespace std;

int main()
{

	char* cmdParams = (char*)malloc(10 * sizeof(char));
	cout << "Enter Time in ms:";
	cin >> cmdParams;
	STARTUPINFOA si;
	PROCESS_INFORMATION pi;

	ZeroMemory(&si, sizeof(si));
	si.cb = sizeof(si);
	ZeroMemory(&pi, sizeof(pi));

	// Start the child process. 
	if (!CreateProcess("D:\\51MAR[gl]\\UPOL\\OS2\\cv-3\\process2\\Debug\\process2.exe", 
		cmdParams,          
		NULL,          
		NULL,          
		FALSE,         
		0,             
		NULL,          
		NULL,          
		&si,           
		&pi)           
		)
	{
		printf("CreateProcess failed (%d).\n", GetLastError());
		return -1;
	}

	WaitForSingleObject(pi.hProcess, INFINITE);

	CloseHandle(pi.hProcess);
	CloseHandle(pi.hThread);
	int n;
	cin >> n;
    return 0;
}

