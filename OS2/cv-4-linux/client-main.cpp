#include <iostream>
#include <fcntl.h>
#include <unistd.h>
#include <cstring>
#include <errno.h>

using namespace std;

#define PIPE_IN "/tmp/pipeW"
#define PIPE_OUT "/tmp/pipeR"
#define BUFFSIZE 512


int main()
{
	int pipeIn = open(PIPE_IN, O_RDWR);
    int pipeOut = open(PIPE_OUT, O_RDWR);
    
    while(true)
    {
        string input;
        size_t count;

        cout << "-> ";
        cin >> input;

        count = write(pipeOut, input.c_str(), input.length());
        
        if(input[0] != '+' && input[0] != '-' && input[0] != '*' && input[0] != '/')
            break;


        char buff[BUFFSIZE];
        count = read(pipeIn, &buff, BUFFSIZE);
        buff[count] = '\0';
        input = buff;

        if(input.length())
        {
            cout << input << endl;
        }
    }
    

    cout << "Quiting client" << endl;
	return 0;
}