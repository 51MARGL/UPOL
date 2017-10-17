// 10-Transformace textu.cpp : Defines the entry point for the console application.
//

#include "stdafx.h"
#include <Windows.h>

int set(char* in, char** out)
{
	int pocet = strlen(in);
	int zmen = 0;
	int i = 0;
	out[0] = (char*)malloc(sizeof(char));
		for (int j = 0; j < pocet; j++)
		{
			if ((in[j] >= 65) && (in[j] <= 90))
			{
				
				out[0][i] = in[j] + 32; i++; zmen++;
			}
			else if ((in[j] >= 97) && (in[j] <= 122))
			{
				
				out[0][i] = in[j] - 32; i++; zmen++;
			}
			else
			{
				
				out[0][i] = in[j]; i++;
			}
		}
		
	return zmen;
}
int main()
{
	char *in=(char*)malloc(sizeof(char));
	char **out=(char**)malloc(sizeof(char*));
	printf("Enter line:");
	scanf("%[^\n]s", in);
	printf("\nline:");
	printf(" %s\n",in);
	int i = set(in, *&out);
	printf("Pocet zmen=%d\n", i);
	printf("%s\n", *out);
	system("pause");
    return 0;
}

