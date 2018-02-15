#include <iostream>
#include "func.h"

using namespace std;
int main(){
    int a,b;
    cout<< "Enter a:" << endl;
    cin>>a;
    cout<< "Enter b: " << endl;
    cin>>b;

    cout<<"Result: " << NSD(a,b) <<endl;

    return 0;
}