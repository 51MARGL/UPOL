// cv-9.cpp : Defines the entry point for the console application.
//

#include "stdafx.h"
#include <string>
#include <iostream>

using namespace std;

unsigned long long measure_mov()
{
	_asm {
		mov ecx, 100

		rdtsc
		push edx
		push eax

		while:
		mov eax, 0
			mov eax, 1
			mov eax, 2
			mov eax, 3
			loop while

			rdtsc
			sub eax, [esp];
			sbb edx, [esp + 4]
			add esp, 8
	}
}

int myAtoi(char *str)
{
	int res = 0;
	for (int i = 0; str[i] != '\0'; ++i)
		res = res * 10 + str[i] - '0';
	return res;
}

unsigned long long measure_mul()
{
	_asm {
		rdtsc
		push edx
		push eax

		mov ecx, 100
		mov eax, 5
		while:
		mul ecx
			mul ecx
			mul ecx
			mul ecx
			loop while

			rdtsc
			sub eax, [esp];
			sbb edx, [esp + 4]
			add esp, 8
	}
}

int myAtoi_asm(char *str)
{
	int res = 0;
	_asm {
		rdtsc
		push edx
		push eax

		mov ebx, 0
		mov esi, str

		push esi
		call strlen
		add esp, 4
		mov ecx, 0

		rec1:
			imul ebx, 10
			movsx edx, byte ptr[esi + ecx]
			add ebx, edx
			sub ebx, '0'
			inc ecx
			cmp ecx, eax
			jl rec1
		end1 :
			mov res, ebx

			rdtsc
			sub eax, [esp];
			sbb edx, [esp + 4]
			add esp, 8
			
			
	}
	cout << "res= " << res << endl;
}

int myAtoi_asm_v2(char *str)
{
	int res = 0;
	_asm {
		rdtsc
		push edx
		push eax

			push str
			call atoi
			add esp,4
			mov res, eax


		rdtsc
		sub eax, [esp];
		sub edx, [esp + 4]
		add esp, 8
	}
	cout << "res= " << res << endl;
}

int main()
{
	printf("mov:     %d\n", measure_mov());
	printf("mul:     %d\n", measure_mul());
	myAtoi("666");
	cout << "atoi: " << myAtoi_asm("1234") << endl;
	cout << "ato2: " << myAtoi_asm_v2("1234") << endl;
	return 0;
}

