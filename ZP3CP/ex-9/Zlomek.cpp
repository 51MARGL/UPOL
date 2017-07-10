#include "stdafx.h"
#include "Zlomek.h"
#include <iostream>
using namespace std;


void Zlomek::nsd() {
	if (c != 0) {
		unsigned a = c, b = j;
		for (;;) {
			unsigned r = a%b;
			if (r == 0) {
				if (b>1) c /= b, j /= b;
				return;
			}
			a = b;
			b = r;
		}
	}
	j = 1;
}

Zlomek::Zlomek()
{
}

Zlomek::Zlomek(unsigned c, unsigned j) :c(c), j(j) {
	nsd();
}

Zlomek Zlomek::operator * (const Zlomek &z) const {
	return Zlomek(c*z.c, j*z.j);
}
Zlomek Zlomek::operator + (const Zlomek &z) const
{
	return Zlomek(c*z.j + z.c*j, j*z.j);
}
Zlomek Zlomek::operator - (const Zlomek &z) const
{
	return Zlomek(c*z.j - z.c*j, j*z.j);
}
Zlomek Zlomek::operator / (const Zlomek &z) const
{
	return Zlomek(c*z.j, j*z.c);
}
Zlomek Zlomek::operator*(unsigned i) const
{
	return Zlomek(c*i, j*1);
}
Zlomek Zlomek::operator+(unsigned i) const
{
	return Zlomek(c*1 + i*j, j*1);
}
Zlomek Zlomek::operator-(unsigned i) const
{
	return Zlomek(c*1 - i*j, j*1);
}
Zlomek Zlomek::operator / (unsigned i) const
{
	return Zlomek(c*1, j*i);
}
unsigned Zlomek::cit() const {
	return c;
}
unsigned Zlomek::jm() const {
	return j;
}
void Zlomek::operator () (const char *s) const { 
	cout << c << '/' << j << s; 
}

bool Zlomek::operator==(const Zlomek &z)
{
	return (c == z.c && j == z.j);
}
double Zlomek::operator+()
{
	return (double)c/j;
}
bool Zlomek::operator!=(const Zlomek &z)
{
	return (c == z.c && j == z.j);
}
