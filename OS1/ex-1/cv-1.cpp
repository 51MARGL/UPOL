// cv-1.cpp : Defines the entry point for the console application.
//

#include "stdafx.h"
#include <iostream>

using namespace std;

typedef struct Node
{
	char *jmeno;
	int vek;
	Node *next;
}TNode;


void int2bits(char *a, int b) {
	for (int i = 31; i >= 0; i--) {
		*a = (1 << i) & b ? '1' : '0';
		a++;
	}
	*a = '\0';
}

int bits2int(char *a) {
	int n = 0;
	for (int i = strlen(a) - 1; i >= 0; i--) {
		if (a[i] == '1') {
			n = n | (1 << (strlen(a)- i -1));
		}
	}
	return n;
}

void my_memset(void *dest, unsigned char c, size_t count)
{
	unsigned char *dest_char = (unsigned char *)dest;

	while (*dest_char && count > 0)
	{
		*dest_char = c;
		dest_char++;
		count--;
	}
}

void  add(TNode *&root, TNode * PNew)
{
	TNode * WP;
	PNew->next = NULL; 
	if (root == NULL) 
	{
		root = PNew; 
		return;    
	}
	WP = root; 
	while (WP->next != NULL)  
	{
		WP = WP->next;  
	}
	WP->next = PNew;
}


void print_nodes(TNode *root)
{
	TNode *node = root;
	while (node != NULL)
	{
		cout << "Jmeno: " << node->jmeno << " Vek: " << node->vek << endl;
		node = node->next;
	}
}


void print(int val1, int val2, int val3)
{
	printf("%d %d %d\n", val1, val2, val3);
}



int main()
{
	cout << "-------test1---------" << endl;
	char a[33];
	int n = 11;
	int2bits(a, n);
	cout << a << endl;

	cout << "-------test2---------" << endl;
	cout << bits2int(a) << endl;

	cout << "-------test3---------" << endl;
	char *str;
	str = strdup("hello");
	my_memset(str, '-', 3);
	printf("%s\n", str);
	
	cout << "-------test4---------" << endl;
	TNode *root = NULL;
	TNode *nodeA = (TNode*)malloc(sizeof(TNode));
	TNode *nodeB = (TNode*)malloc(sizeof(TNode));
	TNode *nodeC = (TNode*)malloc(sizeof(TNode));

	nodeA->jmeno = "Anna";
	nodeA->vek = 5;
	nodeB->jmeno = "Jan";
	nodeB->vek = 6;
	nodeC->jmeno = "Eva";
	nodeC->vek = 7;

	add(root, nodeA);
	add(root, nodeB);
	add(root, nodeC);
	print_nodes(root);

	cout << "-------test5---------" << endl;
	int x = 0;
	print(x++, x++, x++);
    return 0;
}

