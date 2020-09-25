import std;


//open rec r1,r2;tri r3,r4,r5 ; rec r5, r6  close

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

	bool doneFirst = false;

	for(;lastSemi != -1;){
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
					writeln("rec ", tokens[lastSemi+2],' ', tokens[lastSemi+3]);
					return -1;
				}
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

		if(lastSemi == -1 && doneFirst == false){
			lastSemi = 0;
			doneFirst = true;
		}
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

void parseTree(string[] tokens) {
	string partree = "open <stmt_list> close";
	int lastSemi = lastIndexOf(tokens, ";");
	while(partree.indexOf("<") != -1){
		writeln(partree);
		
		if(lastSemi == -1){
			lastSemi = 0;
		}

		int stmt_list = partree.indexOf("<stmt_list>");

		if(stmt_list != -1) {
			if(lastSemi != 0){
				partree = partree.replaceLast("<stmt_list>","<stmt> ; <stmt_list>");
			} else {
				partree = partree.replaceLast("<stmt_list>","<stmt>");
			}
			lastSemi = lastIndexOf(tokens, ";", lastSemi - 1);
			continue;
		}

		int stmt = partree.indexOf("<stmt>");

		if(stmt != -1) {
			if(tokens[lastSemi+1].equal("rec")){
				partree = partree.replaceLast("<stmt>", "rec <coord>, <coord>");
				writeln(partree);

				for(int k = 3; k > 1; k-- ){
					partree = partree.replaceLast("<coord>", "<x><y>" );
					writeln(partree);
					string coord = tokens[lastSemi+k];
					string y = to!string(coord[1]);
					string x = to!string(coord[0]);
					partree = partree.replaceLast("<y>",y);
					writeln(partree);
					partree = partree.replaceLast("<x>",x);
					writeln(partree);
				}
			}
			else if(tokens[lastSemi+1].equal("tri")){
				partree = partree.replaceLast("<stmt>", "tri <coord>, <coord>, <coord>");
				writeln(partree);

				for(int k = 4; k > 1; k-- ){
					partree = partree.replaceLast("<coord>", "<x><y>" );
					writeln(partree);
					string coord = tokens[lastSemi+k];
					string y = to!string(coord[1]);
					string x = to!string(coord[0]);
					partree = partree.replaceLast("<y>",y);
					writeln(partree);
					partree = partree.replaceLast("<x>",x);
					writeln(partree);
				}
			}				
			lastSemi = lastIndexOf(tokens, ";", lastSemi - 1);
			continue;
		}
	}
}

void main()
{

    string str;
    writeln("Please enter the code: (use 'EXIT' to exit)");
    while ((str = stdin.readln()) !is null) {
        if(str == "EXIT\n"){
        	break;
        }
		if(str == "\n") { writeln("Please enter the code: (use 'EXIT' to exit)"); continue;}

    	string[] tokens = tokenizeStr(str);

        if(checkGrammar(tokens) != -1){
		    writeln("\nGrammar Good");
			parseTree(tokens);
		} 

		writeln("\nPlease enter the code: (use 'EXIT' to exit)");
    }

    writeln("ENDING");
}


