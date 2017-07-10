#pragma once
class Zlomek {

	unsigned c, j;           
	void nsd();
public: Zlomek();
		Zlomek(unsigned, unsigned);
		Zlomek operator * (const Zlomek &) const;
		Zlomek operator + (const Zlomek &) const;
		Zlomek operator - (const Zlomek &) const;
		Zlomek operator / (const Zlomek &) const;
		Zlomek operator * (unsigned) const;
		Zlomek operator + (unsigned) const;
		Zlomek operator - (unsigned) const;
		Zlomek operator / (unsigned) const;
		unsigned cit() const;
		unsigned jm() const;
		void operator () (const char *s = "\n") const;
		bool operator == (const Zlomek &);
		double operator + ();
		bool operator != (const Zlomek &);
};


