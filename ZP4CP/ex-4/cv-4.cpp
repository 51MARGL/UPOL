// cv-4.cpp : Defines the entry point for the console application.
//

#include "stdafx.h"
#include <iostream>
#include <set>
#include <string>

using namespace std;

const int M1 = 1, M2 = 2, M5 = 5, M10 = 10, M20 = 20, M50 = 50;

const int pohyb[] = { M5,M5,M2,M2,M1,M50,M2,M5,M5,M5,-M2,M10,M50,M1,M1,-M5,-M5,-M5,M2,-M1,-M10,-M50 };

const unsigned pohybPocet = sizeof pohyb / sizeof *pohyb;

int main()
{
	multiset<int> m;

	for (auto x : pohyb) {
		if(x > 0) 
			m.insert(x);
	}
	for (auto x : m) {
		cout << x << " ";
	}
	cout << endl;
	for (auto x : pohyb) {
		if (x < 0) {
			m.erase(m.find(-x));
		}
	}
	for (auto x : m) {
		cout << x << " ";
	}
	cout << endl;

	set<int> count;
	for (auto x : m) {
		if (m.count(x) > 0) {
			count.insert(x);
		}
	}
	for (auto x : count) {
		cout << "M" << x << " " << m.count(x) << "x" << endl;
	}
    return 0;
}

