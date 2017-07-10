#pragma once
class KO
{
	unsigned const h;
	unsigned p;
public:
	KO(unsigned);
	KO & operator = (unsigned);
	KO & operator = (KO &);
	KO & operator += (KO &);
	KO & operator += (unsigned);
	KO & operator *= (KO &);
	KO & operator *= (unsigned);
	bool & operator ! ();
	bool & operator == (KO &);
	bool & operator == (unsigned);
	bool & operator != (KO &);
	bool & operator != (unsigned);
	operator unsigned () { return h; }



	~KO();
};

