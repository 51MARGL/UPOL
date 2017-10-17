// 7-Studenti.cpp : Defines the entry point for the console application.
//

#include "stdafx.h"
#include <Windows.h>
#include <stdio.h>
typedef struct{
	int den, mesic, rok;
}Datum;

typedef struct{
	char jmeno[20];
	char prijmeni[20];
	Datum narozen;
}Student;
int porovnej_vek(Student s1, Student s2)
{
	if (s1.narozen.rok < s2.narozen.rok) return -1;
	if (s1.narozen.rok == s2.narozen.rok)
	{
		if (s1.narozen.mesic < s2.narozen.mesic)return -1;
		if (s1.narozen.mesic == s2.narozen.mesic)
		{
			if (s1.narozen.den < s2.narozen.den)return -1;
			if (s1.narozen.den == s2.narozen.den)return 0;
		}
	}
	else return 1;
}
int main()
{
	Student s1, s2;
	printf("Jmeno S1:");
	scanf("%s", &s1.jmeno);
	printf("\nPrijmeni S1:");
	scanf("%s", &s1.prijmeni);
	printf("\nDatum S1:(den.mesic.rok):\n");
	scanf("%d.%d.%d", &s1.narozen.den, &s1.narozen.mesic, &s1.narozen.rok);
	printf("\nJmeno S1-%s", s1.jmeno);
	printf("\nPrijmeni S1-%s", s1.prijmeni);
	printf("\nDatum S1:%d.%d.%d\n", s1.narozen.den, s1.narozen.mesic, s1.narozen.rok);
	printf("\nJmeno S2:");
	scanf("%s", &s2.jmeno);
	printf("\nPrijmeni S2:");
	scanf("%s", &s2.prijmeni);
	printf("\nDatum S2:(den.mesic.rok):\n");
	scanf("%d.%d.%d", &s2.narozen.den, &s2.narozen.mesic, &s2.narozen.rok);
	printf("\nJmeno S2-%s", s2.jmeno);
	printf("\nPrijmeni S2-%s", s2.prijmeni);
	printf("\nDatum S2:%d.%d.%d\n", s2.narozen.den, s2.narozen.mesic, s2.narozen.rok);
	int vek = porovnej_vek(s1, s2);
	switch (vek) {
		case 1:printf("\n%s %s je starsi nez %s %s\n", s2.jmeno,s2.prijmeni, s1.jmeno,s1.prijmeni); break;
		case -1:printf("\n%s %s je starsi nez %s %s\n", s1.jmeno,s1.prijmeni, s2.jmeno, s2.prijmeni); break;
		case 0:printf("\n%s %s ma stejny vek jako %s %s\n", s1.jmeno,s1.prijmeni, s2.jmeno,s2.prijmeni); break;
	}
	system("pause");
    return 0;
}

