lexer grammar CoolLexer;

tokens{
	ERROR,
	TYPEID,
	OBJECTID,
	BOOL_CONST,
	INT_CONST,
	STR_CONST,
	LPAREN,
	RPAREN,
	COLON,
	ATSYM,
	SEMICOLON,
	COMMA,
	PLUS,
	MINUS,
	STAR,
	SLASH,
	TILDE,
	LT,
	EQUALS,
	LBRACE,
	RBRACE,
	DOT,
	DARROW,
	LE,
	ASSIGN,
	CLASS,
	ELSE,
	FI,
	IF,
	IN,
	INHERITS,
	LET,
	LOOP,
	POOL,
	THEN,
	WHILE,
	CASE,
	ESAC,
	OF,
	NEW,
	ISVOID,
	NOT
}

/*
  DO NOT EDIT CODE ABOVE THIS LINE
*/

@members{

	/*
		YOU CAN ADD YOUR MEMBER VARIABLES AND METHODS HERE
	*/

	/**
	* Function to report errors.
	* Use this function whenever your lexer encounters any erroneous input
	* DO NOT EDIT THIS FUNCTION
	*/
	public void reportError(String errorString){
		setText(errorString);
		setType(ERROR);
	}

	public void processString() {
		Token t = _factory.create(_tokenFactorySourcePair, _type, _text, _channel, _tokenStartCharIndex, getCharIndex()-1, _tokenStartLine, _tokenStartCharPositionInLine);
		String text = t.getText();
		text = text.substring(1,text.length());

		StringBuilder buffer = new StringBuilder(0);
		String ftext = buffer.toString();

		//write your code to test strings here
		for(int i = 0; i < text.length(); ++i) {
			if(i == text.length()-1) {
				/*
				 Checking last character of string
				*/
				if(text.charAt(i) == '"') {
					setText(ftext);
					setType(STR_CONST);
				}
				else if(text.charAt(i) == '\n') {
					reportError("Unterminated string constant");
					return;
				}
				else if(text.charAt(i) == '\\') {
					reportError("Backslash at end of file");
					return;
				}
				else if(text.charAt(i) == '\u0000') {
					reportError("String contains null character");
					return;
				}
				else if(ftext.length() == 1024) {
					reportError("String constant too long");
					return;
				}
				else {
					reportError("EOF in string constant");
					return;
				}
			}
			else if(text.charAt(i) == '\u0000') {
				reportError("String contains null character.");
				return;
			}
			else if(text.charAt(i) == '\\' && (i+1) < text.length()) {
				if(text.charAt(i+1) == '\u0000') {
					reportError("String contains escaped null character.");
					return;
				}
				/*
				 Any escaped last character except null char in string gives EOF
				*/
				else if(i == text.length()-2) {
					reportError("EOF in string constant");
					return;
				}
				else if(text.charAt(i+1) == 'n')
					buffer.append('\n');
				else if(text.charAt(i+1) == 'f')
					buffer.append('\f');
				else if(text.charAt(i+1) == 't')
					buffer.append('\t');
				else if(text.charAt(i+1) == 'b')
					buffer.append('\b');
				else if(text.charAt(i+1) == '\"')
					buffer.append('\"');
				else if(text.charAt(i+1) == '\\')
					buffer.append('\\');
				else
					buffer.append(text.charAt(i+1));
				i++;
			}
			else {
				buffer.append(text.charAt(i));
			}
			/*
			 If string size gets past the limit,we dont care for remaining string
			*/ 
			ftext = buffer.toString();
			if(ftext.length() > 1024) {
				reportError("String constant too long");
				return;
			}
		}

		ftext = buffer.toString();
		if(ftext.length() > 1024) {
			reportError("String constant too long");
			return;
		}

	}

	/*
	 To process unmatched characters
	*/

	public void processCharacter() {
		Token t = _factory.create(_tokenFactorySourcePair, _type, _text, _channel, _tokenStartCharIndex, getCharIndex()-1, _tokenStartLine, _tokenStartCharPositionInLine);
		String text = t.getText();
		reportError(text);
	}
}

/*
	WRITE ALL LEXER RULES BELOW
*/

SEMICOLON   : ';';
DARROW      : '=>';
LPAREN      : '(' ;
RPAREN      : ')' ;
COLON       : ':' ;
ATSYM       : '@' ;
COMMA       : ',' ;
PLUS        : '+' ;
MINUS       : '-' ;
STAR        : '*' ;
SLASH       : '/' ;
TILDE       : '~' ;
LT          : '<' ;
EQUALS      : '=' ;
LBRACE      : '{' ;
RBRACE      : '}' ;
DOT         : '.' ;
LE          : '<=';
ASSIGN      : '<-';

/*
 Case Insensitive Keywords
*/

CLASS       : ('C'|'c')('L'|'l')('A'|'a')('S'|'s')('S'|'s') ;
ELSE        : ('E'|'e')('L'|'l')('S'|'s')('E'|'e') ;
FI          : ('F'|'f')('I'|'i') ;
IF          : ('I'|'i')('F'|'f') ;
IN          : ('I'|'i')('N'|'n') ;
INHERITS    : ('I'|'i')('N'|'n')('H'|'h')('E'|'e')('R'|'r')('I'|'i')('T'|'t')('S'|'s') ;
LET         : ('L'|'l')('E'|'e')('T'|'t') ;
LOOP        : ('L'|'l')('O'|'o')('O'|'o')('P'|'p') ;
POOL        : ('P'|'p')('O'|'o')('O'|'o')('L'|'l') ;
THEN        : ('T'|'t')('H'|'h')('E'|'e')('N'|'n') ;
WHILE       : ('W'|'w')('H'|'h')('I'|'i')('L'|'l')('E'|'e') ;
CASE        : ('C'|'c')('A'|'a')('S'|'s')('E'|'e') ;
ESAC        : ('E'|'e')('S'|'s')('A'|'a')('C'|'c') ;
OF          : ('O'|'o')('F'|'f') ;
NEW         : ('N'|'n')('E'|'e')('W'|'w') ;
ISVOID      : ('I'|'i')('S'|'s')('V'|'v')('O'|'o')('I'|'i')('D'|'d') ;
NOT         : ('N'|'n')('O'|'o')('T'|'t') ;

/*
 Boolean should have first character in lower case
*/

BOOL_CONST  : 't'('R'|'r')('U'|'u')('E'|'e') | 'f'('A'|'a')('L'|'l')('S'|'s')('E'|'e') ;


INT_CONST  : [0-9]+ ;
TYPEID     : [A-Z][a-z|A-Z|0-9|_]* ;
OBJECTID   : [a-z][a-z|A-Z|0-9|_]* ;

/*
 Skipping all spaces, newlines, tabs
*/

WS         : [ \r\t\n\f\b\u000b]+ -> skip ;

/*
 To manage different types of string bodies
*/

fragment NONEND : (~('\n' | '"' | '\\') | ('\\'.)) ;      
PER_STR   : '"'NONEND*'"' {processString();} ;
NONTER_STR: '"'NONEND*'\n' {processString();} ;
ERR_ST    : '"'(EOF) {reportError("EOF in string constant");} ;
EOF_STR   : '"'NONEND*'\\'?(EOF) {processString();} ;


/*
 Comment Section
*/

LINE_COMMENT: ('--'~('\n')*'\n' | '--'~('\n')*(EOF)) -> skip ;
END_COMMENT : '*)' {reportError("Unmatched *)");} ;
UN_COMMENT  : '*)' EOF {reportError("Unmatched *)");} ;
NON_COMMENT : '(*' EOF {reportError("EOF in comment");} ;
ST_COMMENT  : '(*' ->skip, pushMode(COMMENT_MODE1) ;

/*
 Unmatched character
*/

INCOR_CHAR  : . {processCharacter();} ;

/*
 For multi line nested comments
*/

mode COMMENT_MODE1;
EOF1_START  : '(*'(EOF) {reportError("EOF in comment");} -> mode(DEFAULT_MODE) ;
COM_START   : '(*' -> skip, pushMode(COMMENT_MODE2) ;
COM_END     : '*)' -> skip, popMode ;
EOF_COM     : .(EOF) {reportError("EOF in comment");} -> mode(DEFAULT_MODE) ;
ORELSE      : . -> skip ;

mode COMMENT_MODE2;
EOF2_START  : '(*'(EOF) {reportError("EOF in comment");} -> mode(DEFAULT_MODE) ;
EOF1_COM    : '*)'(EOF) {reportError("EOF in comment");} -> mode(DEFAULT_MODE) ;
COM2_START  : '(*' -> skip, pushMode(COMMENT_MODE2) ;
COM2_END    : '*)' -> skip, popMode ;
EOF2_COM    : .(EOF) {reportError("EOF in comment");} -> mode(DEFAULT_MODE) ;
ORELSE2     : . -> skip ;