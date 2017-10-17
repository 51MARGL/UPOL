// process2.cpp : Defines the entry point for the console application.
//


#include "stdafx.h"
#include <iostream>
#include <Windows.h>
using namespace std;

int main(int argc, char *argv[])
{
	cout << "Start" << endl;
	int startTime = GetTickCount();
	int timeToWait = atoi(argv[0]);
	int endTime = startTime + timeToWait;
	int waitedTime = 0;
	while (GetTickCount() <= endTime) {
		int enter = GetTickCount();
		Sleep(100);
		waitedTime += GetTickCount() - enter;
		cout << "Waited in ms: " << waitedTime << endl;
	}
    return 0;
}

