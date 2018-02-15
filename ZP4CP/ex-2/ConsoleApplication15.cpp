// ConsoleApplication15.cpp : Defines the entry point for the console application.
//

#include "stdafx.h"
#include <iostream>
#include <string>
#include <algorithm>
#include <vector>
using namespace std;


const char *Jmena[] =
{ "Marie","Jan","Jana","Petr","Josef","Pavel","Jaroslav","Martin","Miroslav","Eva",
"Anna","Hana","Karel","Lenka","Milan","Michal","Alena","Petra","Lucie","Jaroslava",
"Ludmila","Helena","David","Ladislav","Marie","Jan","Jana","Petr","Jitka","Martina","Jakub","Veronika","Jarmila","Stanislav",
"Michaela","Ivana","Roman","Jarmila","Monika","Tereza","Zuzana","Radek","Vlasta","Marcela","Marek",
"Dagmar","Dana","Daniel","Marta","Irena","Monika","Miroslava","Barbora","Ilona","Pavla","Miloslav","Olga",
"Andrea","Iveta","Hana","Filip","Ilona","Blanka","Milada","Ivan","Zdenka","Libor","Renata","Rudolf",
"Vlastimil","Nikola","Gabriela","Lenka","Adam","Lenka","Milan","Radka","Simona","Milena","Miloslava","Iva","Daniela",
"Patrik","Bohumil","Denisa","Robert","Diana","Romana","Aneta","Ilona","Dominik","Jakub","Stanislava","Emilie",
"Radim","Richard","Kamila","Ivo","Monika","Rostislav","Vladislav","Bohuslav","Alois","Vit","Kamil",
"Jozef","Vendula","Bohumila","Viktor","Emil","Michael","Ladislava","Diana","Magdalena","Eduard","Dominika",
"Marcel","Adam","Sabina","Julie","David","Johana","Antonie","Josef","Alice","Peter","Dalibor","Kristina","Otakar","Karla",
"Hedvika","Alexandra","Silvie","Erika","Nela","Irena","Vratislav","Nikol","Leona","Jolana","Margita",
"Bohuslava","Radovan","Jan","Jana","Josefa","Terezie","Marian","Linda","Igor","Jarmila","Magda","Lada","Bohumir",
"Alexandr","Radim","Adriana","Dita","Hana","Vladislava","Otto","Sandra","Radmila","Svatava","Darina","Sylva",
"Viktorie","Ivona","David","Monika","Jarmila","Lenka","Bronislava","Elena","Svatopluk","Ivanka","Denis","Adolf","Hynek","Erik",
"Bronislav","Jakub","Drahoslava","Petr","Alexander","Robin","Maria","Diana","Lidmila","Vlastislav","Michala","Jindra",
"Juraj","Vlastimila","Karin","Zdena","Jan","Josef","Jana","Karolina","Mykola","Pavol","Vanda","Radoslav","Zdenek",
"Alenka","Ema","Andrej","Tibor","Anton","Ingrid","Nina","Irena","Viera","Linda","Valerie","Samuel",
"Zlata","Lydie","Tamara","Johana","Jan","Jana","Patricie","Julius","Boris","Leopold","Ota","Ester",
"Gertruda","Sylvie","Aloisie","Oto","Barbara","Gustav","Marika","Yvona","Jitka","Oksana","Bohdan" };


vector<string>::iterator prvni(vector<string> &l, const char *filtr) {
	vector<string>::iterator poz = l.begin();
	string pos = "";
	for (string x : l) {
		for (int i = 0; i < strlen(filtr) && x[i] != '\0'; i++) {
			if (x[i] != filtr[i]) break;
			else if (x[i] != '\0' && i == strlen(filtr) - 1) {
				pos = x;
				poz = find(l.begin(), l.end(), pos);
				cout << pos << endl;
			}
			if (pos != "") break;
		}
	}
	return poz;
	
}

int main()
{
	vector<string> j;
	for (auto x : Jmena) {
		j.push_back(x);
	}
	
	prvni(j, "Iv");
	return 0;
}