#pragma once
class KvadratickaRovnice
{
public: int a, b, c;
public:
	KvadratickaRovnice(int a, int b, int c);
	~KvadratickaRovnice();
	int diskriminant();
	int pocetKorenu();
	int koren1();
	int koren2();
};

