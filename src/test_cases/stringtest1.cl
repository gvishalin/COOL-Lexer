class Main {
	Int a <- 5;

--escaped newline\
"This is\
OK";

\ --Error

--odd number of backslashes, not an error
"This is also\\\
OK";

 --Unterminated, two times because of other "
"This is
error";

--String constant
"This is \\ OK";

--Unterminated, due to escaped "
"Quote is escaped\";

--As escaped new line
"\\\\\
This is OK";

--Unterminated as there is unescaped newline
"\\\\
This is error";

--Multiple unescaped newlines
"This
is
error";

--Contains null char
"This string contains null char  ";

--Contains null char and also unterminated
"Gives the first encountered   error

--Contains escaped null char
"We can see that this string contains escaped null char\ "

}

--EOF directly followed by ", error
"