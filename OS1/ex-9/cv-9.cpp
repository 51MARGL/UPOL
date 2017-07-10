// cv-9.cpp : Defines the entry point for the console application.
//

#include "stdafx.h"
#include <string>
#include <iostream>

using namespace std;
__declspec(naked) int min1(int a, int b) {
	_asm {
		push ebp;
		mov ebp, esp;

			mov eax, [ebp + 8]
			mov ebx, [ebp + 12]
			cmp eax, ebx
			jg end1
			jmp end2
		end1 :
			mov eax, ebx
		end2 :
			mov esp, ebp;
			pop ebp;
			ret;
	}
}

__declspec(naked) int min2(int a, int b) {
	_asm {
		push ebp;
		mov ebp, esp;

			mov eax, [ebp + 8]
			cmp eax, ecx
			jg end1
			jmp end2
	end1:
		mov eax, ecx
	end2:
		mov esp, ebp;
		pop ebp;
		ret;
	}
}
__declspec(naked) int min3(int a, int b) {
	_asm {

		cmp ecx, edx
		jl end1
		mov eax, edx
		jmp end2
		end1:
		mov eax, ecx
		end2:
		ret
	}
}

__declspec(naked) int fact(int n) {
	_asm {
		push ebp; 
		mov ebp, esp;

			mov eax, 1
			mov ebx, [ebp + 8]

			cmp ebx, 1
			je end1
			dec ebx
			push ebx
			call fact
			add esp, 4

			imul eax, [ebp + 8]
	end1:

		mov esp, ebp; 
		pop ebp;
		ret;
	}
}

__declspec(naked) int fact2(int n) {
	_asm {

		mov eax, 1
		mov ebx, ecx

		cmp ebx, 1
		je end1
		dec ebx
		push ebx
		call fact
		add esp, 4

		imul eax, ecx
	end1:
		ret

	}
}

void callFnc() {
	char* format = "min: %d\n";
	char* f2 = "fact %d: %d\n";
	_asm {
		//min1

		push 2
		push 3
		call min1
		add esp, 8

		push eax
		push format
		call printf
		add esp, 8

		//min2
		push 3
		mov ecx, -1
		call min2
		add esp, 4

		push eax
		push format
		call printf
		add esp, 8

		//min3
		mov ecx, -4
		mov edx, 4

		call min3

		push eax
		push format
		call printf
		add esp, 8

		//fact


		push 4
		call fact
		add esp, 4

		push eax
		push 4
		push f2
		call printf
		add esp, 12

		//fact 2
		mov ecx, 4
		call fact2

		push eax
		push 4
		push f2
		call printf
		add esp, 12
	}
}

int main()
{
	callFnc();
	return 0;
}
