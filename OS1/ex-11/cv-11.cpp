// cv-10.cpp : Defines the entry point for the console application.
//

#include "stdafx.h"
#include <iostream>
#include <string>

using namespace std;

double obvod_obdelnika(double a, double b) {
	_asm {
		fld a
		fld b
		fadd st, st(1)
		fadd st, st
	}
}
double obsah_obdelnika(double a, double b) {
	_asm {
		fld a
		fld b
		fmul
	}
}

double obvod_ctverce(double a) {
	
	_asm {
		push 4
		fld a
		fimul dword ptr[esp]
		add esp, 4
	}
}

double obsah_ctverce(double a) {
	_asm {
		fld a
		fmul st,st
	}
}

double obvod_kruhu(double r) {
	_asm {
		fldpi
		fld r
		fmul 
		fadd st,st
	}
}

double obsah_kruhu(double d) {
	_asm {
		push 2
		fld d
		fidiv dword ptr[esp]
		add esp,4
		fmul st,st
		fldpi
		fmul
	}
}

float avg(float a, float b, float c) {
	_asm {
		fld a
		fld b
		fadd
		fld c
		fadd

		push 3
		fidiv dword ptr[esp]
		add esp,4
	}
}

double heron(double a, double b, double c) {
	double s;
	_asm {
		push 2
		fld a
		fld b
		fadd 
		fld c
		fadd
		fidiv dword ptr[esp]
		add esp,4

		fst s

		fld a
		fsub

		fld s
		fld b

		fsub
		fmul

		fld s
		fld c
		fsub
		fmul

		fld s
		fmul

		fabs

		fsqrt
	}
}

int main()
{
	cout << "obvod_obdelnika (5.3, 2.5):            " << obvod_obdelnika(5.3, 2.5) << endl;
	cout << "obsah_obdelnika (5.3, 2.5):            " << obsah_obdelnika(5.3, 2.5) << endl;
	cout << "obvod_ctverce (5.5):                   " << obvod_ctverce(5.5) << endl;
	cout << "obsah_ctverce (5.5):                   " << obsah_ctverce(5.5) << endl;
	cout << "obvod_kruhu (5):                       " << obvod_kruhu(5) << endl;
	cout << "obsah_kruhu (10):                      " << obsah_kruhu(10) << endl;
	cout << "avg1 (1.5, 2.3, 4.8):                  " << avg(1.5, 2.3, 4.8) << endl;
	cout << "avg2 (-1.5, -2.3, -4.8):               " << avg(-1.5, -2.3, -4.8) << endl;
	cout << "heron (1, 1, 1):                       " << heron(1, 1, 1) << endl;
	return 0;
}

