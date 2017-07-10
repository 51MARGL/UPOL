#pragma once
class Seznam
{
	static Seznam *prvni, *iterator;
	int cislo;
	Seznam *dalsi;
public:
	Seznam();
	Seznam(int);
	int prvek() const;
	static bool nastavitNaPrvni();
	static Seznam *aktualni();
	static bool posunoutNaDalsi();
	~Seznam();
};

