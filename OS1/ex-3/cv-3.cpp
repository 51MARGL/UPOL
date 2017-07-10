// cv-3.cpp : Defines the entry point for the console application.
//

#include "stdafx.h"
#include <iostream>

using namespace std;

int avg_int(int a, int b, int c) {
	_asm {
		mov eax,a
		add eax,b
		add eax,c
		cdq
		mov ebx,3
		div ebx
	}
}

short avg_short(short a, short b, short c) {
	_asm {
		mov ax,a
		add ax,b
		add ax,c
		cwd
		mov bx,3
		div bx
	}
}

int min3(unsigned char a, short b, int c) {
	_asm {
		mov eax,0
		mov al,a
		mov bx,b
		cmp ax,bx
		jl next1
greater:
		movsx eax,bx
		
next1:   
		mov ebx,c
		movsx eax,ax
		cmp eax,ebx
		jl next2
greater2:
		mov eax,ebx
next2: 
	}
}

int mocnina(int n, unsigned int m) {
	_asm {
		mov ecx,m
		sub ecx,1
		mov eax,n
		mov ebx,n
	loop1:
		mul ebx
		loop loop1
	}
}

int main()
{
	cout << "avg_int: " << avg_int(3, 2, 4) << endl;

	cout << "avg_short: " << avg_short((short)3, (short)2, (short)1) << endl;
	cout << "mi3: " << min3(3, 2, 1) << endl;
	cout << "mocnina: " << mocnina(3,3) << endl;
    return 0;
}

