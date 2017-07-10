// cv-7.cpp : Defines the entry point for the console application.
//

#include "stdafx.h"
#include <iostream>

using namespace std;

struct foo {
	char* name;
	unsigned int  price;
	unsigned int count;
};

struct foo bar[10];
int iter = 0;

void receipt_add(char *name, unsigned int price, unsigned int count) {
	struct foo newEl;
	newEl.name = name;
	newEl.price = price;
	newEl.count = count;
	bar[iter] = newEl;
	iter++;

}

void receipt_add_asm(char *name, unsigned int price, unsigned int count) {
	_asm {

		mov eax, iter
		mov edx, 12
		imul edx

		mov ecx, eax


		mov eax, name

		mov[bar + ecx], eax
		mov eax, price
		mov[bar + 4 + ecx], eax
		mov eax, count
		mov[bar + 8 + ecx], eax

		inc iter
	}
}

int receipt_total() {
	int sum = 0;
	for (int i = 0; i < iter; i++) {
		sum += bar[i].price;
	}
	return sum;
}

int receipt_total_asm() {
	_asm {
		mov eax, 0
		mov edx, 0
		rec1:
			mov ecx, 12
			imul ecx, edx
			add eax, dword ptr[bar + 4 + ecx]
			inc edx
			cmp edx,iter
			jl rec1
	}
}


void receipt_print() {
	for (int i = 0; i < iter; i++) {
		cout << bar[i].name << " = " << bar[i].price << " : " << bar[i].count << endl;
	}
}

void receipt_print_asm() {
	char *format = "%s = %i : %i\n";;
	_asm {
		mov ebx, 0
		rec1:
			cmp ebx, iter
			jae end1

			mov eax, 12
			mul ebx

			mov esi, [offset bar]
			movsx edx, [esi + eax + 8]
			push edx
			push dword ptr[esi + eax + 4]
			push dword ptr[esi + eax + 0]

			push dword ptr format
			call dword ptr[printf]
			add esp, 16

			inc ebx
			jmp rec1

			end1:
	}
}

int main()
{
	receipt_add_asm("Ananas", 15, 5);
	receipt_add_asm("Banana", 10, 2);

	receipt_print_asm();
	cout << endl;
	receipt_print();

	cout << receipt_total() << endl;
	cout << receipt_total_asm() << endl;
	return 0;
}

