// cv-8.cpp : Defines the entry point for the console application.
//

#include "stdafx.h"
#include <iostream>
#include <bitset>

using namespace std;

int makeMask(int p, int n) {
	_asm {
		mov eax, 0
		mov ebx, p
		mov edx, n
		dec edx
		rec1 :
		add eax, 1
			shl eax, 1
			dec edx
			cmp edx, 0
			jg rec1
			add eax, 1
			cmp ebx, 0
			je end1
			rec2 :

		shl eax, 1
			dec ebx
			cmp ebx, 0
			jg rec2
			end1 :

	}
}

int divide2(int a, int n, int* res, int *rest) {
	_asm {
		mov eax, a
		mov edx, n
		mov esi, res
		mov ebx, rest
		mov edi, 0
		cmp edx, 0
		je end1
		rec1 :
		sar eax, 1
			jc rec2
			jnc rec3
			dec edx
			cmp edx, 0
			jg rec1
			jmp end1
			rec2 :
		shl edi, 1
			add edi, 1
			dec edx
			cmp edx, 0
			jg rec1
			rec3 :
		add edi, 1
			dec edx
			cmp edx, 0
			jg rec1

			end1 :
		mov dword ptr[esi], eax
			mov dword ptr[ebx], edi
	}
}

int add() {
	int i = 0;
	int j = 0;
	_asm {
		mov eax, 1000000000000000000
		mov ebx, 0
		mov ecx, 1000000000000000000
		mov edx, 0
		add eax, ecx
		adc ebx, edx
		mov i, eax
		mov j, ebx

	}
	cout << bitset<32>(j) << "-" << bitset<32>(i) << endl;
}
int sub() {
	int i = 0;
	int j = 0;
	_asm {
		mov eax, 2
		mov ebx, 1
		mov ecx, 10
		mov edx, 0
		sub eax, ecx
		sbb ebx, edx
		mov i, eax
		mov j, ebx

	}
	cout << bitset<32>(j) << "-" << bitset<32>(i) << endl;
}

unsigned int rotl(unsigned int r, unsigned n) {
	if (n == 0) {
		return r;
	}
	if ((n &= 31) == 0) {
		return n;
	}
	return (r << n) | (r >> (32 - n));
}

unsigned int rotr(unsigned int r, unsigned n) {
	if (n == 0) {
		return r;
	}
	if ((n &= 31) == 0) {
		return n;
	}
	return (r >> n) | (r << (32 - n));
}

int multiply(int a) {
	_asm {
		mov eax, a
		mov ebx, eax
		mov ecx, eax
		shl eax, 4
		shl ebx, 3
		add eax, ebx
		add eax, ecx
	}
}

struct arm_num {
	unsigned char ror4;
	unsigned char imm8;
};

arm_num *myA = (arm_num*)malloc(sizeof(arm_num));

int arm_encodable(unsigned int n) {
	for (int i = 0; i < 33; i++) {

		int t = rotl(n, i);
		if (((t >> 8) & 0xFFFFFF) == 0) {
			return i + 1;
		}
	}
	return 0;
}

int arm_encodable_asm(unsigned int n) {
	int i = 0;
	_asm {
		mov eax, n
		mov ecx, 0
		rec1:
		cmp ecx, 32
			je end2
			mov eax, n
			mov ebx, 0
			rec2 :
			rol eax, 1
			inc ebx
			cmp ebx, ecx
			jl rec2
			sar eax, 8
			and eax, 0xFFFFFF
			cmp eax, 0
			je end1
			inc ecx
			jmp rec1
			end1 :
		mov eax, ecx
			inc eax
			mov i, eax
			end2 :
	}
	return i;
}

void arm_decode_parts_asm(unsigned short n, struct arm_num *myA) {
	_asm {
		movzx eax, word ptr[n]
		and eax, 0xFF
		mov ecx, dword ptr[myA]
		mov byte ptr[ecx + 1], al
		movzx eax, word ptr[n]
		and eax, 0xF00
		sar eax, 8
		mov ecx, dword ptr[myA]
		mov byte ptr[ecx], al
	}
}


void arm_decode_parts(unsigned short n, struct arm_num *decoded) {
	char a = 0xFF & n;
	char b = (0xF00 & n) >> 8;
	myA->ror4 = b;
	myA->imm8 = a;

}

unsigned int arm_decode_asm(unsigned short n) {
	int i = 0;
	_asm {
		mov eax, [myA]
		push eax
		movzx ecx, word ptr[n]
		push ecx
		call arm_decode_parts_asm
		add esp, 8

		mov ecx, dword ptr[myA]
		movzx eax, byte ptr[ecx + 1]
		mov ebx, 0
		mov bl, byte ptr[ecx]

		shl bl, 1
		loop1 :
		cmp bl, 0
			je end1
			dec bl
			ror eax, 1
			jmp loop1
			end1 :
		mov i, eax
	}
}

int zeroExtend32(unsigned char imm) {
	int i = 0;
	i |= imm;
	return i;
}

unsigned int arm_decode(unsigned short n) {
	arm_decode_parts(n, myA);
	return rotr(zeroExtend32(myA->imm8), myA->ror4 * 2);
}

unsigned short arm_encode_asm(unsigned int n) {
	_asm {
		push n
		call arm_encodable_asm
		add esp, 4

		mov ecx, eax
		cmp ecx, 0
		je end1
		dec ecx
		mov eax, n
		mov ebx, 0
		rec1:
		rol eax, 1
			inc ebx
			cmp ebx, ecx
			jl rec1

			shl ecx, 7
			or eax, ecx
			and eax, 0xFFF
			end1:
	}
}

unsigned short arm_encode(unsigned int n) {
	int x = arm_encodable(n);
	if (x != 0) {
		x -= 1;
		unsigned short i = 0;
		i = rotl(n, x);
		short j = (x / 2) << 8;
		return (i | j) & 0xFFF;
	}
}

int main()
{
	cout << "Mask = " << bitset<32>(makeMask(3, 4)) << endl;
	int *res = (int*)malloc(sizeof(int));
	int *rest = (int*)malloc(sizeof(int));
	//cout << divide2(15, 3, res, rest) << endl;
	//cout << "resuslt= " << *res << endl;
	//cout << "remainder= " << *rest << endl;
	cout << endl;

	add();
	cout << endl;
	sub();

	cout << "rol: " << bitset<32>(rotl(1, 3)) << endl;
	cout << "rol: " << bitset<32>(rotl(1, 31)) << endl;
	cout << "mul25: " << multiply(5) << endl;

	cout << "encode: " << arm_encode(772) << endl;
	cout << "decode: " << arm_decode(4033) << endl;
	cout << "encode_asm: " << arm_encode_asm(772) << endl;
	cout << "decode_asm: " << arm_decode_asm(4033) << endl;
	return 0;
}

