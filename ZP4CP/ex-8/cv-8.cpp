// cv-8.cpp : Defines the entry point for the console application.
//

#include "stdafx.h"
#include <iostream>
#include <string>
#include <regex>

using namespace std;


const char d[] = { 31,29,31,30,31,30,31,31,30,31,30,31 };

const char *mmm[] =
{ "leden","ledna","unor","unora","brezen","brezna","duben","dubna","kveten","kvetna","cerven","cervna",
"cervenec","cervence","srpen","srpna","zari","zari","rijen","rijna","listopad","listopadu","prosinec","prosince" };

const char *datum[] =
{ "1. 10. 2012", "15. 14. 1990", "26. 5 1982", "22. leden 2010",
"12. listopadu 2005", "31. prosinec 1999", "3. rijna 2012",
"8. srpn 2017", "31. rijen 2010", "31. zari 2014",
"10. 7.2002", "10. 2. 207", "8.12. 2014", "005. 11. 2009",
"19. 011. 1958", "01. 01. 2000", "33. 3. 2003", "31. 9. 2016" };

int getIndexOfArray (const char * element) {
	int i = 0;
	for (auto x : mmm) {
		if (element == mmm[i]) {
			return i;
		}
		i++;
	}
	return -1;
}

int main()
{
	regex r1("([[:d:]]{1,2})\\.([[:space:]]+)([[:d:]]{1,2})\\.([[:space:]]+)([[:d:]]{4})");
	regex r2("([[:d:]]{1,2})\\.([[:space:]]+)([[:alpha:]]+)([[:space:]]+)([[:d:]]{4})");
	cmatch cm;

	for (auto x : datum) {
		if (regex_match(x, cm, r1)) {
			if (stoi(cm[3]) < 13 && stoi(cm[1]) < d[stoi(cm[3])]) {
				cout << x << ": +" << endl;
			}
			else {
				cout << x << ": -" << endl;
			}
		}
		else if (regex_match(x, cm, r2)) {
			bool print = false;
			int i = 0;
			for (auto z : mmm) {
				i = getIndexOfArray(z);
				if (cm[3] == z && stoi(cm[1]) <= (int)d[i/2]) {
					print = true;
				}
			}
			if (print) {
				cout << x << ": +" << endl;
			}
			else {
				cout << x << ": -" << endl;
			}
		}
		else {
			cout << x << ": -" << endl;
		}
	}
	return 0;
}

