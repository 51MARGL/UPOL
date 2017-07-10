// ConsoleApplication4.cpp : Defines the entry point for the console application.
//

#include "stdafx.h"
#include "KvadratickaRovnice.h"
#include <iostream>
using namespace std;

int main()
{
	KvadratickaRovnice *kv = new KvadratickaRovnice(1, -4, 2);
	cout << kv->diskriminant() << endl;
	cout << kv->pocetKorenu() << endl;
	cout << kv->koren1() << endl;
	cout << kv->koren2() << endl;
    return 0;
}

