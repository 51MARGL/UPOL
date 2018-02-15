#include <iostream>
#include <pthread.h>
#include <fstream>
using namespace std;

typedef struct Param
{
	string file;
	char filtr1;
    char filtr2;
    int result;
}param;

void *search(void *arg)
{
	Param *param = (Param*) arg;
	ifstream file (param->file.c_str(), ios::in | ios::binary | ios::ate);
	if(file.is_open())
	{
		file.seekg(0);

		char n;
		while(!file.eof())
		{      
			file.read((char *)&n, sizeof n);
            int size = (int)n;
            char buffer[size];
			file.read(buffer, size);
            if (buffer[0] != param->filtr1){
                continue;
            }                      
            if (buffer[size-1] == param->filtr2){
                param->result++;
            } 
		}
	}
	pthread_exit(0);
}

int main(){

    
    char fF;
    char fL;
	while(true)
	{
		cout << "First letter: ";
        cin >> fF;
        if( (!isalpha(fF)))
        {
            cout<<"Quit"<<endl;
            break;
        }
        cout << "Last letter: ";
        cin >> fL;
        Param param1;
        param1.file = "Jmena1b";
        param1.filtr1 = fF;
        param1.filtr2 = fL;
        param1.result = 0;
        Param param2;
        param2.file = "Jmena2b";
        param2.filtr1 = fF;
        param2.filtr2 = fL;
        param2.result = 0;

		pthread_t thread1, thread2;

		pthread_create(&thread1, NULL, search, (void*) &param1);
		pthread_create(&thread2, NULL, search, (void*) &param2);

		pthread_join(thread1, NULL);
		pthread_join(thread2, NULL);

		cout << "Jmena1b: " << param1.result << endl;
		cout << "Jmena2b: " << param2.result << endl;
	}
    return 0;
}