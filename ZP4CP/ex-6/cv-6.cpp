// cv-6.cpp : Defines the entry point for the console application.
//

#include "stdafx.h"
#include <iostream>
#include <fstream>
#include <string>
#include <set>
using namespace std;

int main()
{
	set<string> namesToWrite;
	try {
		ifstream s("Jmena", ios::binary);
		if (s.is_open()) {
			while (!s.eof()) {
				char x;
				s.read((char*)&x, sizeof(x));
				if (s.eof()) break;

				char *buffer = new char[static_cast<int>(x) + 1];
				s.read(buffer, static_cast<int>(x));
				buffer[static_cast<int>(x)] = '\0';
				namesToWrite.insert(buffer);
			}
			s.close();
		}
		int i = 0;
		for (auto x : namesToWrite) {
			cout << x << endl;
			i++;
		}
		cout << i << endl;

		ofstream w("JmenaC", ios::binary);
		if (w.is_open()) {
			for (auto x : namesToWrite) {
				w.write(x.c_str(), x.size());
				w.write("\0", sizeof(char));
			}
		}
		w.close();
	}
	catch (exception e) {
		cout << "Error!" << endl;
	}

    return 0;
}

