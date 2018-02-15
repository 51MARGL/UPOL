#include <stdlib.h>
#include <iostream>
#include <sys/stat.h>
#include <unistd.h>
#include <cstring>
#include <cmath>
#include <cstdio>
#include <errno.h>
#include <fcntl.h>
#include <algorithm>

using namespace std;

#define PIPE_IN "/tmp/pipeR"
#define PIPE_OUT "/tmp/pipeW"
#define BUFFSIZE 512

int accumulator = 0;

int main()
{
	// Create the pipes
	int pipeIn = mkfifo(PIPE_IN, S_IRUSR | S_IWUSR);
	int pipeOut = mkfifo(PIPE_OUT, S_IRUSR | S_IWUSR);

	pipeIn = open(PIPE_IN, O_RDWR);
    pipeOut = open(PIPE_OUT, O_RDWR);
    
    while(true)
    {
        size_t count;

        char buff[BUFFSIZE];
        count = read(pipeIn, &buff, BUFFSIZE);
        buff[count] = '\0';
        string input(buff);

        char output[BUFFSIZE];
        int inNumber;
        bool exit = false;
        switch(input[0])
        {
            case '+': 
                inNumber = atoi(input.substr(1).c_str());
                accumulator += inNumber;
                break;
            case '-':			
                inNumber = atoi(input.substr(1).c_str());
                accumulator -= inNumber;
                break;
            case '*':		
                inNumber = atoi(input.substr(1).c_str());
                accumulator *= inNumber;
                break;
            case '/':			
                inNumber = atoi(input.substr(1).c_str());
                accumulator /= inNumber;
                break;	
            default:
            {
                exit = true;
                break;
            }
        }
        if (exit)
            break;
        sprintf(output,"%d",accumulator);
        write(pipeOut, output, strlen(output));
    }
	

	// Close the pipe
	unlink(PIPE_IN);
	unlink(PIPE_OUT);

	cout << "Quiting server" << endl;
	return 0;
}