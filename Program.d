import std;

// This function finds the index of a string in an array.
// Returns -1 if not found.
int lastIndexOf(string[] tokens, string text, int start = -1) {
	// Ensures start position is valid
	if(start < 0 || start >= tokens.length){
		start = tokens.length - 1;
	}

	// Goes through array, beginning at start position.
  for(int i = start; i >= 0; i--){
    if(tokens[i].equal(text)){
			// Returns position
			return i;
		}
	}

	// Returns -1 if not found.
	return -1;
}

// Strips the string into different segments of the grammar.
// Seperates words, ';', and ','
string[] tokenizeStr(string str) {
	// Initially seperates by empty space.
  string[] a = str.split(regex("[\r\n\t\f\v ]"));

  // Finds and seperates semi colons. 
  for(int i = a.length - 1; i >= 0 ; i--) {

  	// Looks for a ';' within string.
		if(a[i].indexOf(';') != -1){

			// Seperates the ';' from the string.
      string[] b = a[i].split(";");

      // Inserts it into its place
      for(int k = 0; k < b.length; k++) {
				if(b[k].equal("")){
			    b[k]=";";
					break;
				}
        if(k == 1) {
			    b.insertInPlace(1, ";");
				}
			}

			// Replaces the old string
			// with the seperate strings
      a = a.replace(i, i+1, b);
		}
	}

	// Finds and seperates ','
	for(int i = a.length - 1; i >= 0 ; i--) {
		// Determines if the comma is already seperated.
		if(a[i].equal(",")) { continue; }

		// Determines if string has a comma
		if(a[i].indexOf(',') != -1){
			
			// Seperates words by ','
      string[] b = a[i].split(",");
			
			// Variable to see if any empty spaces has been filled
			bool emptySpace = false;

			// Looks For Empty Space and Fills it
      for(int k = b.length - 1; k >= 0; k--) {
				if(b[k].equal("")){
			    b[k]=",";
					emptySpace = true;
				}
			}

			// If no empty space, then put ',' in center
			if(!emptySpace){
				for(int k = b.length - 1; k > 0; k--) {
				    b.insertInPlace(k, ",");
				}
			}

			// Replace old text with new text.
      a = a.replace(i, i+1, b);
			i = a.length - 1;
		}
	}

	// Remove any empty space from array.
  for(int i = a.length - 1; i >= 0; i--){
    if(a[i].equal("")){
	    a = a.remove(i);
		}
	}

	// Writeln is for Debugging
  // writeln(a);
  // Returns the now tokenized string
  return a;
}

// Checks the grammar of the string.
// Uses the previously created tokens.
// Returns -1 if there is an error in syntax.
int checkGrammar(string[] tokens) {
	// Checks if program begins with 'open'
	// And ends with 'close'
	if(!(tokens[0].equal("open"))){
		writeln("Program must start with open.");
		return -1;
	}
	if(!(tokens[tokens.length - 1].equal("close"))){
		writeln("Program must end with close.");
		return -1;
	}

	// Amount of times to loop
	int loop = 1;
	for(int i = 0; i < tokens.length; i++){
		if(tokens[i].equal(";")){
			loop++;
		}
	}

	// Loops through all statements
	for(;loop>0; loop--){

		// Begins check at rightmost sequence.
		int lastSemi = lastIndexOf(tokens, ";");
		// Starts at open, if no ';' found
		if(lastSemi == -1){
			lastSemi = 0;
		}

		int coordNum;
		if(tokens[lastSemi + 1].equal("rec")){
			coordNum = 2;
		} else if(tokens[lastSemi + 1].equal("tri")){
			coordNum = 3;
		} else {
			generateError(tokens, lastSemi, tokens[lastSemi + 1] ~ " is not a command");
			return -1;
		}

		// Look for Segment Fault Errors
		if(lastSemi + (2 * coordNum) >= tokens.length){
			generateError(tokens, lastSemi, "Not enough Arguments:");
			return -1;
		}

		// Look for correct number of arguments
		int hasCoords = 1;
		for(int i = 1; tokens[lastSemi + (1 + (2 * i))].equal(","); i++){
			hasCoords++;
		}

		if(hasCoords != coordNum){
			generateError(tokens, lastSemi, "Wrong number of Arguments: ");
			return -1;
		}

		// Checks if Coords are valid
		for(int i = 1; i <= coordNum; i++){
			string coord = tokens[lastSemi + 2 * i];

			switch(checkCoord(coord)){
				case -1:
					generateError(tokens, lastSemi, coord ~ " is not a valid coordinate at");
					return -1;
				case -2:
					generateError(tokens, lastSemi, coord ~ " is not a valid coordinate. Must be 2 characters long. at");
					return -1;
				default:
					break;
			}
		}
	}

	// Return no Error	
  return 0;
}

void generateError(string[] tokens, int pos, string message){
	writeln(message);
	string error = "";
	for(int i = 1 + pos; i < tokens.length && !tokens[i].equal(";") ; i++){
		error = error ~ tokens[i] ~ " ";
	}
	writeln(error);
}

// Checks if a coordinate is valid
int checkCoord(string coord) {
	// A coordinate must be 2 characters long.
	if(coord.length != 2){
		return -2;
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

// Does the Parsing
void parseTok(string[] tokens) {
	// Initialization of Parse String
	string parString = "open <stmt_list> close";

	// Initialization of Tree Array
	string[][] treeArr = [
							["<program>"], 
							["/", "|", "\\"], 
							["open", "<stmt_list>", "close"], //Guaranteed to Exist
						  [], // |
						  [], // STMT
						  [], // |
						  [], // Rec
						  [], // |
						  [], // X, Y
						  [], // |
						  []  // Value
						  ];

	// Initialize Variables
	int currtreeArrPos = 3; // Current Position on TreeArr
	int numOfStatements = 0;// Number of Statements
	
	// Add more arrays to tree depending on number of statements
	for(int i = 0; i < tokens.length; i++){
		if(tokens[i].equal(";")){
			treeArr ~= [[],[]];
		}
	}

	// Find last Semi
	int lastSemi = lastIndexOf(tokens, ";");
	// Replace <stmt_list> with corresponding tag
	while (parString.indexOf("<stmt_list>") != -1){
		writeln(parString);

		if(lastSemi != -1){
			// If not last statement, add a next <stmt_list>
			parString = parString.replaceLast("<stmt_list>","<stmt> ; <stmt_list>");

			// Adds lines to first 4 rows of tree arr
			treeArr[currtreeArrPos] ~= ["/", "\\"] ;
			treeArr[currtreeArrPos + 1] ~= ["<stmt>;", "<stmt_list>"] ;
			for(int i = 0; i <= numOfStatements; i++) {
				treeArr[currtreeArrPos + 2] ~= ["|"];
				treeArr[currtreeArrPos + 3] ~= ["|"];	
			}
		} else {
			// If last statement, add only a <stmt>
			parString = parString.replaceLast("<stmt_list>","<stmt>");

			// Adds line and stmt to tree arr
			treeArr[currtreeArrPos] ~= ["|"] ;
			treeArr[currtreeArrPos + 1] ~= ["<stmt>"]  ;
		}
		
		// Move the current position two lines below
		currtreeArrPos += 2;

		// Move to next statement
		lastSemi = lastIndexOf(tokens, ";", lastSemi - 1);
		numOfStatements++;
	}

	// Set to rightmost statement
	lastSemi = lastIndexOf(tokens, ";");
	// Search for '<' which is start of tag
	while(parString.indexOf("<") != -1){
		writeln(parString);
		
		if(lastSemi == -1){
			lastSemi = 0;
		}

		// Replace <stmt> with corresponding command
		int coordNum; // Used to log the amount of coordinates to process
		if(tokens[lastSemi+1].equal("rec")){
			coordNum = 2; // rec holds 2 coordinates
			parString = parString.replaceLast("<stmt>", "rec <coord>, <coord>");

			// Add components to the tree array
			treeArr[currtreeArrPos] = ["/", "|", "\\"] ~ treeArr[currtreeArrPos];
			treeArr[currtreeArrPos + 1] = ["rec ", "<coord>,", "<coord>"] ~ treeArr[currtreeArrPos + 1];
			treeArr[currtreeArrPos + 2] = ["/","\\", "/","\\" ] ~ treeArr[currtreeArrPos + 2];
			treeArr[currtreeArrPos + 3] = ["<x>", "<y>","<x>", "<y>"] ~ treeArr[currtreeArrPos + 3];
		}
		else if(tokens[lastSemi+1].equal("tri")){
			coordNum = 3;	// rec holds 3 coordinates
			parString = parString.replaceLast("<stmt>", "tri <coord>, <coord>, <coord>");
		
			// Add components to the tree array
			treeArr[currtreeArrPos] = ["/", "|", "\\", "\\"] ~ treeArr[currtreeArrPos];
			treeArr[currtreeArrPos + 1] = ["tri ", "<coord>,", "<coord>,", "<coord>"] ~ treeArr[currtreeArrPos + 1];
			treeArr[currtreeArrPos + 2] = ["/","\\", "/","\\" , "/", "\\"] ~ treeArr[currtreeArrPos + 2];
			treeArr[currtreeArrPos + 3] = ["<x>", "<y>","<x>", "<y>","<x>", "<y>"] ~ treeArr[currtreeArrPos + 3];
		}


		writeln(parString); // Output Line
		currtreeArrPos += 4;// Move down the Tree Array

		// Dynamically create the Coordinates  
		string [][] outpCoordArr = [[],[]];
		for(int k = 2 * coordNum; k > 1; k-=2 ){
			// Replace the coord tag with the x and y tags
			parString = parString.replaceLast("<coord>", "<x><y>" );
			writeln(parString);

			// Process the coordinate
			string coord = tokens[lastSemi+k];
			string y = to!string(coord[1]);
			string x = to!string(coord[0]);

			// y coordinate in parse string
			parString = parString.replaceLast("<y>",y);

			// y coordinate in coordinate array
			outpCoordArr[0] = [" | "] ~ outpCoordArr[0];
			outpCoordArr[1] = [y] ~ outpCoordArr[1];
			writeln(parString);

			// x coordinate in parse string
			parString = parString.replaceLast("<x>",x);

			// x coordinate in coordinate array
			outpCoordArr[0] = [" | "] ~ outpCoordArr[0];
			outpCoordArr[1] = [x]  ~ outpCoordArr[1];
			writeln(parString);
		}

		// Add the coordinate array to the tree array
		treeArr[currtreeArrPos] = outpCoordArr[0] ~ treeArr[currtreeArrPos];
		treeArr[currtreeArrPos + 1] = outpCoordArr[1] ~ treeArr[currtreeArrPos + 1];

		// Move back up the tree
		currtreeArrPos-= 4;
		
		// Add space for below the statement word
		// Just styling
		treeArr[currtreeArrPos + 2] = [" ", " "] ~ treeArr[currtreeArrPos + 2];
		treeArr[currtreeArrPos + 3] = [" ", " "] ~ treeArr[currtreeArrPos + 3];
		treeArr[currtreeArrPos + 4] = [" ", " "] ~ treeArr[currtreeArrPos + 4];
		treeArr[currtreeArrPos + 5] = [" ", " "] ~ treeArr[currtreeArrPos + 5];

		// Move to the next statement
		lastSemi = lastIndexOf(tokens, ";", lastSemi - 1);
	}

	// Print the tree using the tree array
	printParseTree(treeArr);
}

// Used to center words in a given length
string getPrintLine(string x, int len){
	int space = (len - x.length)/2;

	// Ensures no overflow
	if(space > len){
		return x;
	}

	// Add spaces
	for(int i = 0; i < space; i++){
		x = " " ~ x ~ " ";
	}

	// Return styled line
	return x;
}

// Prints the tree with the 
void printParseTree(string[][] treeArr){

	// The target width for the tree
	int treeL = 160;

	// Print tree with loop
	for(int i = 0; i < treeArr.length; i++){
		// Initial string
		string outp = "";
		// Line Width depends on amount of items
		int lw = treeL/treeArr[i].length;

		// Get full line
		for (int k = 0; k < treeArr[i].length; k++){
			outp ~= getPrintLine(treeArr[i][k], lw);
		}

		// Reach target width
		while(outp.length < treeL){
			outp = " " ~ outp ~ " ";
		}

		writeln(outp, '\n');
	}
}


void main()
{

    string str;
    // Print Grammar
    writeln(` 
    	Program Grammar:
			<program>   ->  open <stmt_list> close
			<stmt_list> ->  <stmt>
			               | <stmt> ; <stmt_list>
			<stmt>      ->  rec <coord>,<coord>
			           ->  | tri <coord>,<coord>,<coord>
			<coord>     ->  <x><y>
			<x>         ->  r | s | t | u | v | w | x
			<y>         ->  1 | 2 | 3 | 4 | 5 | 6 |
    `);
    writeln("Please enter the code: (use 'EXIT' to exit or 'HELP' for grammar again.)");
    // Reads line
    while ((str = stdin.readln()) !is null) {
      if(str == "EXIT\n"){
      	break; 																					// Break on "EXIT"
      }
      if(str == "HELP\n"){															// Grammar on "HELP"
      	writeln(` 
		    	Program Grammar:
					<program>   ->  open <stmt_list> close
					<stmt_list> ->  <stmt>
					               | <stmt> ; <stmt_list>
					<stmt>      ->  rec <coord>,<coord>
					           ->  | tri <coord>,<coord>,<coord>
					<coord>     ->  <x><y>
					<x>         ->  r | s | t | u | v | w | x
					<y>         ->  1 | 2 | 3 | 4 | 5 | 6 |
		    `);
    		writeln("Please enter the code: (use 'EXIT' to exit or 'HELP' for grammar again.)");
		    continue;
      }
			// Restate prompt on empty
			if(str == "\n") { writeln("Please enter the code: (use 'EXIT' to exit or 'HELP' for grammar again.)"); continue;}

			// Main Program
	  	string[] tokens = tokenizeStr(str);

	    if(checkGrammar(tokens) != -1){
		    writeln("\nGrammar Good");
				parseTok(tokens);
			} 

			// Restate prompt
			writeln("Please enter the code: (use 'EXIT' to exit or 'HELP' for grammar again.)");
    }

    // End program
    writeln("ENDING");
}

