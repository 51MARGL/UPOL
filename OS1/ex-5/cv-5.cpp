// cv-5.cpp : Defines the entry point for the console application.
//

#include "stdafx.h"
#include <iostream>

using namespace std;

void factorial_iter(unsigned char a, unsigned long *b)
{
	if (a <= 1) return;
	*b *= a;
	factorial_iter(a - 1, b);
}

unsigned long factorial(unsigned char a)
{
	unsigned long ret = 1, *pret = &ret;

	_asm {
		push dword ptr pret
		push dword ptr a
		call factorial_iter
		add esp, 8
	}
	return ret;
}

void print_fact(unsigned char n) {
	char *a  = "fact(%d) = %d";
	_asm {
		push n
		call factorial
		add esp,4

		push eax
		push n
		push a
		call printf

		add esp, 12
	}
	
}
void print_facts(unsigned char n) {
	_asm {
		movzx edx, n
		mov ebx, 0

		rec1:
			push ebx
			call print_fact
			add esp, 4
			inc bl
			cmp bl, n
			jl rec1
	}
}
char *abcs(unsigned char n) {
	char* s = "Oops";
	_asm {
		movzx edx, n
		cmp edx,26
		jle next1
	end0:
			mov edx,5
			push edx
			call malloc
			add esp, 4

			push s
			push eax
			call strcpy
			add esp,8
			jmp exit1

	next1:
		push edx
		call malloc
		add esp, 4
		
		mov ecx,0
		mov bl,65
		mov edx,1
		imul edx,n
		rec1:
		    cmp ecx,edx
			je end1	
			mov [eax + 1 * ecx], bl
			inc ecx
			inc bl
			jmp rec1
		end1:
				mov byte ptr[eax + 1 * ecx],'\0'
		exit1:
	}
}
int main()
{
	printf("%s", abcs(27));
	cout << endl;
	print_fact(4);
	cout << endl;
	print_facts(5);
	cout << endl;
    return 0;
}

