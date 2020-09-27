The Program is found in Program D

Below is Depracated Code. Please Ignore.

import std;


//open rec r1, r2;tri r3 ,r4, r5 ; rec r5 ,r6  close
//open rec r1, r2; tri r3, r4, r5 close

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
    string[] a = str.split(regex("[\r\n\t\f\v ]"));

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

	for(int i = a.length - 1; i >= 0 ; i--) {
		if(a[i].equal(",")) { continue; }
		if(a[i].indexOf(',') != -1){
			
            string[] b = a[i].split(",");
			bool emptySpace = false;
            for(int k = b.length - 1; k >= 0; k--) {
				if(b[k].equal("")){
				    b[k]=",";
					emptySpace = true;
				}
			}

			if(!emptySpace){
				for(int k = b.length - 1; k > 0; k--) {
				    b.insertInPlace(k, ",");
				}
			}

            a = a.replace(i, i+1, b);
			i = a.length - 1;
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
    int lastSemi = lastIndexOf(tokens, ";");
	if(lastSemi == -1){
		lastSemi = 0;
	}

	if(!(tokens[0].equal("open"))){
		writeln("Program must start with open.");
		return -1;
	}
	if(!(tokens[tokens.length - 1].equal("close"))){
		writeln("Program must end with close.");
		return -1;
	}

	bool doneFirst = false;

	for(;lastSemi != -1;){
		int nextCheck = lastSemi;

		if(tokens[++nextCheck].equal("rec")){
			if(lastSemi + 4 >= tokens.length){
				writeln("Not enough Arguments for rec: ");
				string error = "";
				for(int i = 1; lastSemi + i < tokens.length; i++){
					error = error ~ tokens[lastSemi + i] ~ " ";
				}
				writeln(error);
				return -1;
			}

			if(!tokens[lastSemi + 3].equal(",") || tokens[lastSemi + 5].equal(",") ){
				writeln("Wrong number of Arguments for rec: ");
				string error = "";
				for(int i = 1; lastSemi + i < tokens.length && !tokens[lastSemi + i].equal(";") ; i++){
					error = error ~ tokens[lastSemi + i] ~ " ";
				}
				writeln(error);
				return -1;
			}
			
			string coord;

			nextCheck += 1;
			for(int i = 0; i < 2; i++){
				coord = tokens[nextCheck];
				nextCheck += 2;

				if(checkCoord(coord) == -1){
					writeln(coord, " is not a valid coordinate at");
					writeln("rec ", tokens[lastSemi+2],',', tokens[lastSemi+4]);
					return -1;
				}
			}

		} else if(tokens[nextCheck].equal("tri")){
			if(lastSemi + 6 >= tokens.length){
				writeln("Not enough Arguments for tri: ");
				string error = "";
				for(int i = 1; lastSemi + i < tokens.length; i++){
					error = error ~ tokens[lastSemi + i] ~ " ";
				}
				writeln(error);
				return -1;
			}

			if(!tokens[lastSemi + 3].equal(",") || !tokens[lastSemi + 5].equal(",") || tokens[lastSemi + 7].equal(",") ){
				writeln("Wrong number of Arguments for tri: ");
				string error = "";
				for(int i = 1; lastSemi + i < tokens.length && !tokens[lastSemi + i].equal(";") ; i++){
					error = error ~ tokens[lastSemi + i] ~ " ";
				}
				writeln(error);
				return -1;
			}

			string coord;
			nextCheck += 1;
			for(int i = 0; i < 3; i++){
				coord = tokens[nextCheck];
				nextCheck += 2;

				if(checkCoord(coord) == -1){
					writeln(coord, " is not a valid coordinate at");
					writeln("tri ", tokens[lastSemi+2], ',', tokens[lastSemi+4], ',', tokens[lastSemi+6]);
					return -1;
				}
			}
		} else {
			writeln(tokens[nextCheck] ~ " is not a valid command at");
			string error = "";
			for(int i = 1; lastSemi + i < tokens.length && !tokens[lastSemi + i].equal(";") ; i++){
				error = error ~ tokens[lastSemi + i] ~ " ";
			}
			writeln(error);
			return -1;
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

string[][] derivation(string[] tokens) {
	string partree = "open <stmt_list> close";
	string[][] outpArr = [["<program>"], ["/", "|", "\\"], ["open", "<stmt_list>", "close"], //Guaranteed to Exist
						  [], // |
						  [], // STMT
						  [], // |
						  [], // Rec
						  [], // |
						  [], // X, Y
						  [], // |
						  [] // Value
						  ];
	int currOutpArrPos = 3;
	int progCount = 1;
	int timesPassed = 0;
	for(int i = 0; i < tokens.length; i++){
		if(tokens[i].equal(";")){
			progCount++;
			outpArr ~= [[],[]];
		}
	}
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
				outpArr[currOutpArrPos] ~= ["/","        ", "\\"] ;
				outpArr[currOutpArrPos + 1] ~= ["<stmt>", ";", "<stmt_list>"] ;
				for(int i = 0; i <= timesPassed; i++) {
					if(tokens[lastSemi+1].equal("rec")){
						outpArr[currOutpArrPos + 2] ~= [" ",  "|", " ", " ", " ", " ", " ", " "," ", " "];
						outpArr[currOutpArrPos + 3] ~= [" ",  "|", " ", " ", " ", " ", " ", " "," ", " "];
					} else {
						outpArr[currOutpArrPos + 2] ~= [" ",  "|", " ", " ", " ", " ", " ", " ", " ", " ", " ", " "];
						outpArr[currOutpArrPos + 3] ~= [" ",  "|", " ", " ", " ", " ", " ", " ", " ", " ", " ", " "];
					}
					
				}
				currOutpArrPos += 2;
			} else {
				partree = partree.replaceLast("<stmt_list>","<stmt>");
				if(timesPassed) {
					outpArr[currOutpArrPos] ~= ["\\"] ;
				}
				else {
					outpArr[currOutpArrPos] ~= ["|"] ;
				}
				outpArr[currOutpArrPos + 1] ~= ["<stmt>"]  ;
				currOutpArrPos += 2;
			}
			lastSemi = lastIndexOf(tokens, ";", lastSemi - 1);

			timesPassed++;
			continue;
		}

		int stmt = partree.indexOf("<stmt>");

		if(stmt != -1) {
			if(tokens[lastSemi+1].equal("rec")){
				partree = partree.replaceLast("<stmt>", "rec <coord>, <coord>");

				writeln(partree);

				outpArr[currOutpArrPos] = ["/", "|", "\\"] ~ outpArr[currOutpArrPos];
				outpArr[currOutpArrPos + 1] = ["rec ", "<coord>", ",", "<coord>"] ~ outpArr[currOutpArrPos + 1];
				outpArr[currOutpArrPos + 2] = ["/","\\", "     ", "/","\\" ] ~ outpArr[currOutpArrPos + 2];
				outpArr[currOutpArrPos + 3] = ["<x>", "<y>","<x>", "<y>"] ~ outpArr[currOutpArrPos + 3];
				currOutpArrPos += 4;

				string [][] outpCoordArr = [[],[" "]];
				for(int k = 4; k > 1; k-=2 ){
					partree = partree.replaceLast("<coord>", "<x><y>" );
					writeln(partree);
					string coord = tokens[lastSemi+k];
					string y = to!string(coord[1]);
					string x = to!string(coord[0]);
					partree = partree.replaceLast("<y>",y);
					outpCoordArr[0] = [" | "] ~ outpCoordArr[0];
					outpCoordArr[1] = [y] ~ " "  ~ outpCoordArr[1];
					writeln(partree);
					partree = partree.replaceLast("<x>",x);
					outpCoordArr[0] = [" | "] ~ outpCoordArr[0];
					outpCoordArr[1] = [x] ~ " "  ~ outpCoordArr[1];
					writeln(partree);
				}
				outpArr[currOutpArrPos] = outpCoordArr[0] ~ outpArr[currOutpArrPos];
				outpArr[currOutpArrPos + 1] = outpCoordArr[1] ~ outpArr[currOutpArrPos + 1];
				currOutpArrPos+=2;

			}
			else if(tokens[lastSemi+1].equal("tri")){
				partree = partree.replaceLast("<stmt>", "tri <coord>, <coord>, <coord>");
				writeln(partree);
			
				outpArr[currOutpArrPos] = ["/", "|", "\\", "\\"] ~ outpArr[currOutpArrPos];
				outpArr[currOutpArrPos + 1] = ["tri ", "<coord>", ",", "<coord>", ",", "<coord>"] ~ outpArr[currOutpArrPos + 1];
				outpArr[currOutpArrPos + 2] = ["/","\\","     ", "/","\\" ,"     ", "/", "\\"] ~ outpArr[currOutpArrPos + 2];
				outpArr[currOutpArrPos + 3] = ["<x>", "<y>","<x>", "<y>","<x>", "<y>"] ~ outpArr[currOutpArrPos + 3];
				currOutpArrPos += 4;
				string [][] outpCoordArr = [[],[" "]];
				for(int k = 6; k > 1; k-=2 ){
					partree = partree.replaceLast("<coord>", "<x><y>" );
					writeln(partree);
					string coord = tokens[lastSemi+k];
					string y = to!string(coord[1]);
					string x = to!string(coord[0]);
					partree = partree.replaceLast("<y>",y);
					outpCoordArr[0] = [" | "] ~ outpCoordArr[0];
					outpCoordArr[1] = [y] ~ " "  ~ outpCoordArr[1];
					writeln(partree);
					partree = partree.replaceLast("<x>",x);
					outpCoordArr[0] = [" | "] ~ outpCoordArr[0];
					outpCoordArr[1] = [x] ~ " " ~ outpCoordArr[1];
					writeln(partree);
				}

				outpArr[currOutpArrPos] = outpCoordArr[0] ~ outpArr[currOutpArrPos];
				outpArr[currOutpArrPos + 1] = outpCoordArr[1] ~ outpArr[currOutpArrPos + 1];
				currOutpArrPos+=2;
			}				
			currOutpArrPos-= 6;
			
			if(lastSemi != 0){
				//outpArr[currOutpArrPos - 2] = "" ~ outpArr[currOutpArrPos - 2];
				//outpArr[currOutpArrPos - 1] = "" ~ outpArr[currOutpArrPos - 1];

//				outpArr[currOutpArrPos + 0] = "----------------------" ~ outpArr[currOutpArrPos + 0];
//				outpArr[currOutpArrPos + 1] = "-" ~ outpArr[currOutpArrPos + 1];
//				outpArr[currOutpArrPos + 2] = "--------------" ~ outpArr[currOutpArrPos + 2];
//				outpArr[currOutpArrPos + 3] = "------------" ~ outpArr[currOutpArrPos + 3];
//				outpArr[currOutpArrPos + 4] = "------------" ~ outpArr[currOutpArrPos + 4];
//				outpArr[currOutpArrPos + 5] = "-----------" ~ outpArr[currOutpArrPos + 5];
				writeln(outpArr);

			}

			lastSemi = lastIndexOf(tokens, ";", lastSemi - 1);
			
		}

	}

	return outpArr;
}

string[][] generateParseTree(int num){
	string[][] a = [["a"], ["b"]];
	return a;
}

string getPrintLine(string x, int len){
	int space = (len - x.length)/2;

	if(space > len){
		return x;
	}

	for(int i = 0; i < space; i++){
		x = " " ~ x ~ " ";
	}

	return x;
}

void printParseTree(string[][] treeArr){
	int frontSpace = 5;
	for(int i = 0; i < treeArr.length; i++){
		string outp = "";
		for(int k = 0; k < treeArr[i].length; k++){
			outp ~= treeArr[i][k] ~ " ";
		}

		if(treeArr[i][0].equal("/")){
			frontSpace += treeArr[i+1][0].length / 2;
		} else if(treeArr[i][0].equal("|")){
			frontSpace += treeArr[i+1][0].length / 2;
		}

		for(int fs= 0; fs < frontSpace; fs++){
			outp = " " ~ outp;
		}

		if(treeArr[i][0].equal("/")){
			frontSpace -= treeArr[i+1][0].length / 2;
		} else if(treeArr[i][0].equal("|")){
			frontSpace -= treeArr[i+1][0].length / 2;
		}

		writeln(outp);
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

    	//string[] tokens = tokenizeStr(str);

        //if(checkGrammar(tokens) != -1){
		//    writeln("\nGrammar Good");
		//	string[][] treeArr = derivation(tokens);
			
		//	printParseTree(treeArr);
		//} 

		writeln(getPrintLine(str, 50));

		writeln("\nPlease enter the code: (use 'EXIT' to exit)");
    }

    writeln("ENDING");
}


