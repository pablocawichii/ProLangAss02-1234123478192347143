import std;


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

    //writeln(a);
    return a;
}

int checkGrammar(string[] tokens) {
    int lastSemi = lastIndexOf(tokens, ";");
	if(lastSemi == -1){
		lastSemi = 1;
	}

	if(!(tokens[0].equal("open"))){
		return -1;
	}
	if(!(tokens[tokens.length - 1].equal("close"))){
		return -1;
	}

	for(;lastSemi > 0;){
		int nextCheck = lastSemi;

		if(tokens[++nextCheck].equal("rec")){
			if(lastSemi + 3 >= tokens.length){
				writeln("Not enough Arguments for rec: ");
				string error = "rec ";
				for(int i = 0; lastSemi + i < tokens.length; i++){
					error = error ~ tokens[i] ~ " ";
				}
				writeln(error);
				return -1;
			}	
			
			string coord;
			for(int i = 0; i < 2; i++){
				coord = tokens[++nextCheck];

				if(checkCoord(coord) == -1){
					writeln(coord, " is not a valid coordinate at");
					writeln("rec ", tokens[lastSemi+2],',', tokens[lastSemi+3]);
					return -1;
				}//writeln("There may not be enough Arguments for tri at index ", nextCheck);
			}

		} else if(tokens[nextCheck].equal("tri")){
			if(lastSemi + 4 >= tokens.length){
				writeln("Not enough Arguments for tri at index ", nextCheck);
				string error = "tri ";
				for(int i = 0; lastSemi + i < tokens.length; i++){
					error = error ~ tokens[i] ~ " ";
				}
				writeln(error);
				return -1;
			}			

			string coord;
			for(int i = 0; i < 3; i++){
				coord = tokens[++nextCheck];

				if(checkCoord(coord) == -1){
					writeln(coord, " is not a valid coordinate at");
					writeln("tri ", tokens[lastSemi+2],' ', tokens[lastSemi+3],' ', tokens[lastSemi+4]);
					return -1;
				}
			}
		}
		
		lastSemi = lastIndexOf(tokens, ";", lastSemi-1);
	}

    return 0;
}

int checkCoord(string coord) {
	if(coord.length != 2){
		return -1;
	}

	// r | s | t | u | v | w | x 
	switch(coord[0]) {
		case 'r':
		case 's':
		case 't':
		case 'u':
		case 'v':
		case 'w':
		case 'x':
			break;
		default:
			writeln(coord[0]," is not an allowed x coordinate.");
			return -1;
	}

	// 1 | 2 | 3 | 4 | 5 | 6 | 
	switch(coord[1]) {
		case '1':
		case '2':
		case '3':
		case '4':
		case '5':
		case '6':
			break;
		default:
			writeln(coord[1]," is not an allowed y coordinate.");
			return -1;
	}

	return 0;
}
void main()
{

    string str;
    writeln("Please enter the code: (use 'EXIT' to exit)");
    while ((str = stdin.readln()) !is null) {
        if(str == "EXIT\n"){
        	break;
        }
    	string[] tokens = tokenizeStr(str);

        if(checkGrammar(tokens) != -1){
		    writeln("\nGrammar Good");
		} 

		writeln("\nPlease enter the code: (use 'EXIT' to exit)");
    }

    writeln("ENDING");
}


