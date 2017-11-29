// cv-5.cpp : Defines the entry point for the console application.
//

#include "stdafx.h"
#include "ABBA.h"
#include <iostream>
#include <map>

using namespace std;

bool findABBA(map<pair<int,char>,int> mapAutomat, const char *str) {
	int actual = 1;
	for (int i = 0; i < strlen(str); i++) {
		actual = mapAutomat[make_pair(actual, str[i])];
	}
	return actual < 0;
}

int main() {
	map<pair<int, char>, int> mapAutomat;

	for (auto x : ABBA) {
		mapAutomat[make_pair(x.soucasnyStav, x.znak)] = x.nasledujiciStav;
	}

	cout << (findABBA(mapAutomat, vstup1) ? "nalezen" : "nenalezen") << endl;

	cout << (findABBA(mapAutomat, vstup2) ? "nalezen" : "nenalezen") << endl;
    return 0;
}

