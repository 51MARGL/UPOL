// cv-2.cpp : Defines the entry point for the console application.
//

#include "stdafx.h"
#include <iostream>

using namespace std;

int obvod_obdelnika(int a, int b) {
	_asm {
		mov eax,a
		add eax,b
		add eax,eax
	}
}

int obsah_obdelnika(int a, int b) {
	_asm {
		mov eax,a
		imul eax,b
	}
}

int obvod_ctverce(int a) {
	_asm {
		mov eax,a
		imul eax,4
	}
}

int obsah_ctverce(int a) {
	_asm {
		mov eax,a
		imul eax,a
	}
}

int obvod_trojuhelnika(int a, int b, int c) {
	_asm {
		mov eax, a
		add eax, b
		add eax, c
	}
}

int obvod_trojuhelnika2(int a) {
	_asm{
		mov eax,a
		imul eax,3
	}
}

int obsah_trojuhelnika2(int a, int b) {
	_asm {
		mov eax, a
		imul eax,b
		mov edx, 0
		mov ebx, 2
		div ebx
	}
}

int obsah_trojuhelnika3(int a, int va) {
	return obsah_trojuhelnika2(a, va);
	
}

int objem_krychle(int a) {
	_asm {
		mov eax,a
		imul eax,a
		imul eax,a
	}
}

float heron(int a, int b, int c) {
	int s;
	int result;

	_asm {
		
		mov eax, a
		add eax, b
		add eax, c
		mov edx, 0
		mov ebx, 2
		div ebx

	
		mov s, eax

		
		mov ebx, s
		sub ebx, a
		imul eax,ebx

	
		mov ebx, s
		sub ebx, b
		imul eax, ebx

		
		mov ebx, s
		sub ebx, c
		imul eax, ebx

		mov result, eax
	}

	return sqrt((float)result);
}
int main()
{
	printf("Obvod obdelnika (2,5): %d\n", obvod_obdelnika(2, 5));
	printf("Obsah obdelnika (2,5): %d\n", obsah_obdelnika(2, 5));
	printf("Obvod ctverce (5): %d\n", obvod_ctverce(5));
	printf("Obsah ctverce (3): %d\n", obsah_ctverce(3));
	printf("Obvod trojuhelnika (5,2,3): %d\n", obvod_trojuhelnika(5, 2, 3));
	printf("Obvod trojuhelnika2 (5): %d\n", obvod_trojuhelnika2(5));
	printf("Obsah trojuhelnika2 (5,4): %d\n", obsah_trojuhelnika2(5, 4));
	printf("Obsah trojuhelnika3 (5,4): %d\n", obsah_trojuhelnika3(5, 4));
	printf("Obsah trojuhelnika3 (5): %d\n", objem_krychle(5));
	cout << heron(5, 5, 5) << endl;;
    return 0;
}

