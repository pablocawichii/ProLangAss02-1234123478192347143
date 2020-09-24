import std;
import std.typecons : Yes;


//open rec r1,r1;tri r1,r1,r1 ; rec r1, r1  close

int lastIndexOf(string[] tokens, string text, int start = -1) {
	if(start < 0 || start >= tokens.length){
		start = tokens.length - 1;
	}
    for(int i = start; i >= 0; i--){
	    if(tokens[i].equal(text)){
			return i;
		}
	}
	return -1;
}

string[] tokenizeStr(string str) {
    string[] a = str.split(regex("[\r\n\t\f\v, ]"));

    for(int i = a.length - 1; i >= 0 ; i--) {
		if(a[i].indexOf(';') != -1){

            string[] b = a[i].split(";");
            for(int k = 0; k < b.length; k++) {
				if(b[k].equal("")){
				    b[k]=";";
					break;
				}
                if(k == 1) {
				    b.insertInPlace(1, ";");
				}
			}
            a = a.replace(i, i+1, b);
		}
	}

    for(int i = a.length - 1; i >= 0; i--){
	    if(a[i].equal("")){
		    a = a.remove(i);
		}
	}

    writeln(a);
    return a;
}

int checkGrammar(string[] tokens) {
    int nextCheck = lastIndexOf(tokens, ";", 8);
	if(nextCheck == -1){
		nextCheck = 1;
	}

	writeln(nextCheck);

    return 0;
}

void main()
{

    string str;
    writeln("Please enter the code: ");
    while ((str = stdin.readln()) !is null) {
        if(str == "EXIT\n"){
        	break;
        }
    	string[] tokens = tokenizeStr(str);

        if(checkGrammar(tokens) != -1){
		    
		} 

		writeln("Please enter the code: ");
    }

    writeln("ENDING");
}


