// cv-4.cpp : Defines the entry point for the console application.
//

#include "stdafx.h"
#include <iostream>

using namespace std;

static int int_array[10];
static short short_array[10];

void countdown() {
	_asm {
		mov eax,10
		mov ecx,0

		rec:
			mov [int_array + 4 * ecx],eax
			inc ecx
			dec eax
			cmp ecx,10
			jl rec
	}
	for (auto x : int_array) {
		cout << x << ", ";
	}
	cout << endl;
}
void mocniny2() {
	int *a = (int*)malloc(sizeof(int)*10);
	_asm {

		mov ecx,2
		mov esi,a
		mov eax,1
		mov [esi],eax
		mov eax,2
		mov [esi + 4],eax
		mov ebx,2
		rec:
			imul ebx
			mov [esi + 4 * ecx],eax
			inc ecx
			cmp ecx,10
			jl rec
	}
	for (int i = 0; i < 10; i++) {
		cout << a[i] << ", ";
	}
	cout << endl;
}

int minimum() {
	int int_array2[10] = { 10, 11, 3, 15, 1, 11, 8, 4, 3, -13 };

	_asm {
		mov ecx,0
		rec1:
			mov eax,[int_array2 + 4 * ecx]
			rec2:
				inc ecx
				cmp ecx, 10
				je ex
				cmp eax,[int_array2 + 4 * ecx]
				jg rec1
				jmp rec2
			ex:
	}
}


int main()
{
	countdown();

	mocniny2();
	cout << minimum() << endl;
    return 0;
}

