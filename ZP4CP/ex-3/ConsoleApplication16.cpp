// ConsoleApplication16.cpp : Defines the entry point for the console application.
//

#include "stdafx.h"
#include <list>
#include <iostream>
#include <string>
using namespace std;

const char *Jmena[] =
{ "Marie","Jan","Jana","Petr","Josef","Pavel","Jaroslav","Martin","Miroslav","Eva",
"Anna","Hana","Karel","Lenka","Milan","Michal","Alena","Petra","Lucie","Jaroslava",
"Ludmila","Helena","David","Ladislav","Jitka","Martina","Jakub","Veronika","Jarmila","Stanislav",
"Michaela","Ivana","Roman","Monika","Tereza","Zuzana","Radek","Vlasta","Marcela","Marek",
"Dagmar","Dana","Daniel","Marta","Irena","Miroslava","Barbora","Pavla","Miloslav","Olga",
"Andrea","Iveta","Filip","Blanka","Milada","Ivan","Zdenka","Libor","Renata","Rudolf",
"Vlastimil","Nikola","Gabriela","Adam","Radka","Simona","Milena","Miloslava","Iva","Daniela",
"Patrik","Bohumil","Denisa","Robert","Romana","Aneta","Ilona","Dominik","Stanislava","Emilie",
"Radim","Richard","Kamila","Ivo","Rostislav","Vladislav","Bohuslav","Alois","Vit","Kamil",
"Jozef","Vendula","Bohumila","Viktor","Emil","Michael","Ladislava","Magdalena","Eduard","Dominika",
"Marcel","Sabina","Julie","Antonie","Alice","Peter","Dalibor","Kristina","Otakar","Karla",
"Hedvika","Alexandra","Silvie","Erika","Nela","Vratislav","Nikol","Leona","Jolana","Margita",
"Bohuslava","Radovan","Josefa","Terezie","Marian","Linda","Igor" };

const unsigned Pocet = sizeof Jmena / sizeof *Jmena;

const char *JmenaN[] =
{ "Alena","Jitka","Robert","Sabina","Julie","Nikol","Klara","Romeo" };

const unsigned PocetN = sizeof JmenaN / sizeof *JmenaN;

const char *JmenaZ[] =
{ "marie","jan","petr","josef","jaroslav","miroslav","eva",
"anna","karel","milan","michal","alena","jaroslava",
"ludmila","ladislav","martina","jakub","veronika","jarmila","stanislav",
"ZUZANA","VLASTA","MARCELA",
"DAGMAR","DANA","DANIEL","MARTA","MIROSLAVA","BARBORA","PAVLA","MILOSLAV","OLGA",
"ANDREA","IVETA","FILIP","MILADA","ZDENKA","RUDOLF",
"vlastimil","nikola","gabriela","milena","miloslava","daniela",
"patrik","bohumil","denisa","aneta","ilona","stanislava","emilie",
"radim","kamila","ivo","rostislav","vladislav","bohuslav","alois","vit","kamil",
"JOZEF","VENDULA","BOHUMILA","MICHAEL","LADISLAVA","MAGDALENA","EDUARD","DOMINIKA",
"JULIE","ANTONIE","PETER","KRISTINA","OTAKAR","KARLA",
"HEDVIKA","ALEXANDRA","ERIKA","NELA","VRATISLAV","JOLANA","MARGITA",
"BOHUSLAVA","JOSEFA","TEREZIE","IGOR" };

const unsigned PocetZ = sizeof JmenaZ / sizeof *JmenaZ;

const char *JmenaZN[] =
{ "Alena","DALIBOR","MARIAN","SABINA","silvie","dominik","nikol","klara","romeo" };

const unsigned PocetZN = sizeof JmenaZN / sizeof *JmenaZN;




int main()
{
	list<string> jmena;
	for (int i = 0; i < Pocet; i++) {
		jmena.push_back(Jmena[i]);
	}
	jmena.sort();
	for (auto x : jmena) {
		cout << x << " ";
	}
	cout << endl << endl;

	for (int i = 0; i < PocetN; i++) {
		bool found = false;
		for (auto x : jmena) {
			const char* p_c_str = x.c_str();
			if (stricmp(p_c_str, JmenaN[i]) == 0) {
				cout <<"Found: "<< x << endl;
				found = true;
			}
		}
		if (!found) cout << "Not found: " << JmenaN[i] << endl;
	}

	for (int i = 0; i < PocetZ; i++)
	{
		for (auto x : jmena) {
			const char* p_c_str = x.c_str();	
			if (stricmp(p_c_str, JmenaZ[i]) == 0) {
				jmena.remove(x);
				break;
			}
		}
	}
	cout << endl;

	for (int i = 0; i < PocetZN; i++) {
		bool found = false;
		for (auto x : jmena) {
			const char* p_c_str = x.c_str();
			if (stricmp(p_c_str, JmenaZN[i]) == 0) {
				cout << "Found: " << x << endl;
				found = true;
			}
		}
		if (!found) cout << "Not found: " << JmenaZN[i] << endl;
	}

	cout << endl << endl;
	cout << endl;
    return 0;
}

