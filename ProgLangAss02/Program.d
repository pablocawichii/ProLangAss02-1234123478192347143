import std;

int find(string ins) {
    for(int i = to!int(ins.length) -1; i >= 0; i--) {
    	writeln(ins[i]);
    }
    return 0;
}

void programErrors(string str) {
}


void main()
{

    string str;
    writeln("Please enter the code: ");
    while ((str = stdin.readln()) !is null) {
        if(str == "EXIT\n"){
        	break;
        }
    	programErrors(str);
		writeln("Please enter the code: ");
    }

    writeln("ENDING");
}


