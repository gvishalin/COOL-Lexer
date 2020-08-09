# COOL Lexer #

## Lexical Analyzer using ANTLR4

AUTHOR: G. Vishal Siva Kumar

------

**Contents:**

------

- README.md

- CoolLexer.g4

*Test Cases:*

> - helloworld.cl
> - stringtest1.cl
> - stringtest2.cl
> - stringtest3.cl
> - commtest1.cl
> - commtest2.cl
> - symbol.cl

------

### Lexer Design
------

The lexer rules are written in the following order below and the order of tokenizing the elements is the same.

- Special symbols
- Keywords
- Boolean constants
- Integer constants
- Identifiers
- Whitespaces
- Strings
- Line comments
- Multi line comments
- Invalid characters

------

### Design Rules
------

#### Special symbols

These are the special symbols which are reserved in cool compiler.

	; => ( ) : @ , + - * / ~ < = { } . <= ,-

#### Keywords

The keywords which are reserved in cool are case insensitive.

#### Boolean constants

Boolean constants should start with lower case character but the rest of the characters are case insensitive.

*Example:*

	tRUE
	fAlSe

These both are valid boolean constants.

#### Integer constants

Floating point constants cannot be represented directly in cool but integers are formed by combination of characters from ``[0-9]``.

#### Identifiers

There are two types of identifiers.

- Type identifiers
- Object identifiers

Identifiers can contain integers, characters from ``[a-z]``, ``[A-Z]`` and ``_``.

**Type** identifiers start with **uppercase** letters.

**Object** identifiers start with **lowercase** letters.

#### Whitespaces

We skip all the spaces, tabs, vertical tabs, new lines and other characters of whitespaces.

Whitespaces:``[ \r\t\n\f\b\u000b]``

#### Strings

In this implimentation, Strings are categorised into 3 types:

- Strings that terminate

> Strings that start and end with ``"``.

- Unterminated strings

> Strings that start with ``"`` and end with ``\n``.

- Strings that contain EOF

> Strings that start with ``"`` and doesn't end with ``\n`` or ``"`` and immediately followed by (EOF).

Rules are designed to match strings of these types and ``processString();`` is called for all these strings. Whenever we encounter ``\`` we also consider it's immediate character with it ,so that we can match escaped newlines, null characters and escaped \". This way string with EOF are also matched and sent to ``processString();``. We even pass the last character which isn't part of string like ``"``, ``\n`` to check the string completely.

A special case is designed for ``"`` immediately followed by (EOF) which reports error message ``EOF in string constant``.

In ``processString();`` we iterate string from start to the end. So, we have to report the error which occurs first in the iteration. 

***Errors like string containing null character, escaped null character, EOF in string, unterminated string, String constant too long and backslash at EOF are handled in ``processString();``.***

In ``processString();``, iterator ``i`` is incremented by either ``1`` in normal cases or ``2`` when it contains a ``\\`` and the next element has to be escaped. So iterator either finally checks last element or last but one element.

**It is given that any string whose length greater than 1024 must be reported as ``String constant too long``, but there are inconsistencies in COOL compiler results for strings containing null character at the end with length 1025, 1026 and 1027. It isn't specified clearly, so we are implementing the rule of maximum String length 1024 and will check the last 1025th char for errors like unterminated(``\n``), null character(``\u0000``), backslash at EOF(``\``) or EOF in string(if no other character is present) and terminated(``"``). Specific examples based on these are provided in the test cases.**

Just before start of every iteration we check the length of the string which is built until then. If it's 1024, we'll check only the next element to decide if it's terminated or for other errors. If there aren't any errors or string isn't terminated then string is considered to be ``too long`` and further check of string input is not done. Lexing resumes after the end of this string.

**Checking last element**

As escaped characters are taken as pairs that is ``(\\(.))`` if we are checking last character, it means that this last character isn't escaped.

- If last character is ``"``, then we consider string as terminated.

- If last character is ``\n``, then we report ``Unterminated string constant`` as there is no other character after this.

- If last character is ``\``, then we report ``Backslash at end of file`` as there is no other character after this.

- If last character is ``\u0000``, then we report ``String contains null character``.

- Any other character will lead to ``String constant too long`` if this is **1025**th character. Or else ``EOF in string constant``.

Now if we check the last but one element and it's not escaped, then we iterate to the next element which is same as the case above. So the other case arises when the last but one element is ``\``. As we check escaped chars in pairs, we check the next element in the same iteration.

- When we encounter ``\``, we check for specific characters like ``n``, ``f`` since these are not escaped but denotes spaces and tabs etc,. And other characters which are checked are ``"`` and ``\`` as escaped ``"`` doesn't end a string and escaped ``\`` is just a character in string.

- Any of the rest characters are just appended into the output buffer string.

Example:

> `` '\\' 'n' gives '\n' in the out put``

> `` '\\' 's' gives 's' in the output``

**Checking last but one element**

Last but one character will be ``\`` as we already said otherwise it'll be same case as the last element check.

- If element after ``\`` is ``\u0000``, then reports error as ``String contains escaped null character``. This error may even take place anywhere in input, not just in the end.

- Now after checking for ``\u0000`` any character that comes after ``\`` will be escaped and there is no more input to take, that is ``EOF``. We report ``EOF in string constant``.

After reporting errors, lexing resumes after the end of the string. And all the errors are checked. So this implimentation handles the errors and provides correctly matched tokens and strings.

**This implimentation gives the error token at the line number where the string starts, but this is different in COOL compiler. I tried to impliment it but was unable to do so. The error message matches but the line number doesn't in some cases**

#### Line comments

``--`` marks the start of the line comment if it occurs outside a terminated string. If this occurs inside a terminated string, they'll be considered as characters in string constant. A new line or ``EOF`` ends this line comment.

#### Multi line comments

Multi line comments are used to write block comments. In COOL, multi line comments can be nested.

Multi line comments begins with ``(*`` and ends with ``*)``, but care must be taken in nested cases as number of opening and closing braces of these comments must match.

If we encounter ``*)`` before ``(*`` then we report ``Unmatched *)``. If we encounter EOF in multi line comments, that is file ends with out matching ``*)``, we report ``EOF in comments``.

For nested scenarios, we use two modes ``COMMENT_MODE1`` and ``COMMENT_MODE2``. Whenever we encounter first ``(*`` we change mode to ``COMMENT_MODE1`` except the case when ``EOF`` is directly followed. If we encounter another ``(*`` in comments, we enter ``COMMENT_MODE2``.

And ``COMMENT_MODE2`` is recursively called if ``(*`` appear again. We pop out from that mode when we encounter ``*)``. If we encounter ``EOF`` in these modes then we report ``EOF in comments``. Multi line comments are perfectly closed if we pop out of ``COMMENT_MODE1``. But reports error if lexer encounters ``EOF`` in those modes.

#### Invalid characters

Input characters which are not matched to any of these above rules are considered as invalid characters and are passed to ``processCharacter();``. ``processCharacter();`` will then return error message with that specific character.

------

### Testing
------

Extensive testing has been done on this lexer and outputs are compared to that of the original COOL lexer output files.

***Cases of some inconsistencies has been observed with 1025,1026 and 1027 sized strings which contain null character at the end. COOL manual provided to us states that 1024 is the maximum allowed length of the string and remaining input for string with more than 1024 length is not considered and lexing starts after the end of that string.***

**Strict rule of string having maximum length of 1024 is followed in this lexer**

Some test cases which contain edge cases and mostly covers the bounds of the lexer are provided.

Three test cases mainly focused on strings are provided. Two test cases are provided for comments. One test case for special symbols is also provided. Moreover the ``helloworld.cl`` test case which is provided to us is slightly modified.

Overall this lexer has undergone extensive testing for maintaining the correctness and lexer code is commented briefly to make code more understandable. Detailed explanation is provided in this readme.

