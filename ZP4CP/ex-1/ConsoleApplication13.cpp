// ConsoleApplication13.cpp : Defines the entry point for the console application.
//

#include "stdafx.h"
#include <iostream>
#include <string>

using namespace std;

int main()
{

	string v("In the C++ programming language, the retez trida is a standard representation for a retez of text.\n"
		"The trida provides some typical retez operations like comparison, concatenation, find and replace.\n");

	string s[] = { string("retez"),string("string"),string("trida"),string("class") };

	cout << v << endl;
	
	int sLength = (sizeof(s) / sizeof(*s));
	for (int i = 0, j = v.find(s[i]); (j < v.size()) && (i < sLength); j = v.find(s[i])) {
		v.replace(j, s[i].length(), s[i + 1]);
		if (v.find(s[i]) >= v.size()) {
			i += 2;
		}
	}

	cout << v << endl;
    return 0;
}

