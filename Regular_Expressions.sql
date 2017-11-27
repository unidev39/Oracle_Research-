1. What Are Regular Expressions?
	Regular expressions enable you to search for patterns in string data by using standardized syntax conventions. 
	You specify a regular expression through the following types of characters:
		* Metacharacters, which are operators that specify search algorithms
		* Literals, which are the characters for which you are searching

2. Oracle Database Implementation of Regular Expressions?
	Oracle Database implements regular expression support with a set of Oracle Database SQL functions and conditions 
	that enable you to search and eveipulate string data. You can use these functions in any environment that supports 
	Oracle Database SQL. You can use these functions on a text literal, bind variable, or any column that holds character data 
	such as CHAR, NCHAR, CLOB, NCLOB, NVARCHAR2, and VARCHAR2 (but not LONG).

3. Oracle Database Support for the POSIX Regular Expression Standard?
	Oracle Database implementation of regular expressions conforms to the following standards:
		* IEEE Portable Operating System Interface (POSIX) standard
		* Unicode Regular Expression Guidelines of the Unicode Consortium
	Oracle Database follows the exact syntax and matching seevetics for these operators as defined in the POSIX standard for matching 
	ASCII (English language) data.
	
4. POSIX Metacharacters in Oracle Database Regular Expressions?
	a1)Syntax => .
		* Operator_Name => Any Character — Dot
		* Description   => Matches any character in the database character set. If the n flag is set, it matches the newline character. 
						   The newline is recognized as the linefeed character (\x0a) on Linux, UNIX, and Windows or the carriage 
						   return character (\x0d) on Macintosh platforms.
						   Note: In the POSIX standard, this operator matches any English character except NULL and the newline character.
		* Example       => The expression a.b matches the strings abb, acb, and adb, but does not match acc.
		
	a1)Syntax => +
		* Operator_Name => One or More — Plus Quantifier
		* Description   => Matches one or more occurrences of the preceding subexpression.
		* Example       => The expression a+ matches the strings a, aa, and aaa, but does not match bbb.
		
	a1)Syntax => ?
		* Operator_Name => Zero or One — Question Mark Quantifier
		* Description   => Matches zero or one occurrence of the preceding subexpression.
		* Example       => The expression ab?c matches the strings abc and ac, but does not match abbc.
		
	a1)Syntax => *
		* Operator_Name => Zero or More — Star Quantifier
		* Description   => Matches zero or more occurrences of the preceding subexpression. By default, a quantifier match is "greedy," because 
		                   it matches as evey occurrences as possible while allowing the rest of the match to succeed.
		* Example       => The expression ab*c matches the strings ac, abc, and abbc, but does not match abb.
		
	a1)Syntax => {m}
		* Operator_Name => Interval—Exact Count
		* Description   => Matches exactly m occurrences of the preceding subexpression.
		* Example       => The expression a{3} matches the strings aaa, but does not match aa.
	
	a1)Syntax => {m,}
		* Operator_Name => Interval—At Least Count
		* Description   => Matches at least m occurrences of the preceding subexpression.
		* Example       => The expression a{3,} matches the strings aaa and aaaa, but does not match aa.

	a1)Syntax => {m,n}
		* Operator_Name => Interval—Between Count
		* Description   => Matches at least m, but not more than n occurrences of the preceding subexpression.
		* Example       => The expression a{3,5} matches the strings aaa, aaaa, and aaaaa, but does not match aa.
		
	a1)Syntax => [ ... ]
		* Operator_Name => Matching Character List
		* Description   => Matches any single character in the list within the brackets. The following operators are allowed within the list, 
		                   but other metacharacters included are treated as literals:
							* Range operator: -
							* POSIX character class: [: :]
							* POSIX collation element: [. .]
							* POSIX character equivalence class: [= =]
							A dash (-) is a literal when it occurs first or last in the list, or as an ending range point in a range expression, 
							as in [#--]. A right bracket (]) is treated as a literal if it occurs first in the list.
							Note: In the POSIX standard, a range includes all collation elements between the start and end of the range in the 
								  linguistic definition of the current locale. Thus, ranges are linguistic rather than byte values ranges; the seevetics 
								  of the range expression are independent of character set. In Oracle Database, the linguistic range is determined by 
								  the NLS_SORT initialization parameter.
		* Example       => The expression [abc] matches the first character in the strings all, bill, and cold, but does not match any characters in doll.

	a1)Syntax => [^ ... ]
		* Operator_Name => Nonmatching Character List
		* Description   => Matches any single character not in the list within the brackets. Characters not in the nonmatching character list are returned 
		                   as a match. See the description of the Matching Character List operator for an account of metacharacters allowed in the character 
						   list.
		* Example       => The expression [^abc] matches the character d in the string abcdef, but not the character a, b, or c. 
		                   The expression [^abc]+ matches the sequence def in the string abcdef, but not a, b, or c.
                           The expression [^a-i] excludes any character between a and i from the search result. 
						   This expression matches the character j in the string hij, but does not match any characters in the string abcdefghi.

	a1)Syntax => |
		* Operator_Name => Or
		* Description   => Matches one of the alternatives.
		* Example       => The expression a|b matches character a or character b.

	a1)Syntax => ( ... )
		* Operator_Name => Subexpression or Grouping
		* Description   => Treats the expression within parentheses as a unit. The subexpression can be a string of literals or a complex expression containing
		                   operators.
		* Example       => The expression (abc)?def matches the optional string abc, followed by def. Thus, the expression matches abcdefghi and def, but does 
		                   not match ghi.

	a1)Syntax => \n
		* Operator_Name => Backreference
		* Description   => Matches the nth preceding subexpression, that is, whatever is grouped within parentheses, where n is an integer from 1 to 9. 
		                   The parentheses cause an expression to be remembered; a backreference refers to it. A backreference counts subexpressions 
						   from left to right, starting with the opening parenthesis of each preceding subexpression. The expression is invalid if the 
						   source string contains fewer than n subexpressions preceding the \n.
						   Oracle Database supports the backreference expression in the regular expression pattern and the replacement string of the 
						   REGEXP_REPLACE function.
		* Example       => The expression (abc|def)xy\1 matches the strings abcxyabc and defxydef, but does not match abcxydef or abcxy.
                           A backreference enables you to search for a repeated string without knowing the actual string ahead of time. 
						   For example, the expression ^(.*)\1$ matches a line consisting of two adjacent instances of the same string.

	a1)Syntax => \
		* Operator_Name => Escape Character
		* Description   => Treats the subsequent metacharacter in the expression as a literal. Use a backslash (\) to search for a character that is normally 
		                   treated as a metacharacter. Use consecutive backslashes (\\) to match the backslash literal itself.
		* Example       => The expression \+ searches for the plus character (+). It matches the plus character in the string abc+def, but does not match 
		                   abcdef.

	a1)Syntax => ^
		* Operator_Name => Beginning of Line Anchor
		* Description   => Matches the beginning of a string (default). In multiline mode, it matches the beginning of any line within the source string.
		* Example       => The expression ^def matches def in the string defghi but does not match def in abcdef.

	a1)Syntax => $
		* Operator_Name => End of Line Anchor
		* Description   => Matches the end of a string (default). In multiline mode, it matches the beginning of any line within the source string.
		* Example       => The expression def$ matches def in the string abcdef but does not match def in the string defghi.

	a1)Syntax => [:class:]
		* Operator_Name => POSIX Character Class
		* Description   => Matches any character belonging to the specified POSIX character class. You can use this operator to search for characters 
		                   with specific formatting such as uppercase characters, or you can search for special characters such as digits or punctuation 
						   characters. The full set of POSIX character classes is supported.
                           Note: In English regular expressions, range expressions often indicate a character class. For example, [a-z] indicates any 
						         lowercase character. This convention is not useful in multilingual environments, where the first and last character of 
								 a given character class might not be the same in all languages.
		* Example       => The expression [[:upper:]]+ searches for one or more consecutive uppercase characters. This expression matches DEF in the 
		                   string abcDEFghi but does not match the string abcdefghi.

	a1)Syntax => [.element.]
		* Operator_Name => POSIX Collating Element Operator
		* Description   => Specifies a collating element to use in the regular expression. The element must be a defined collating element in the current 
		                   locale. Use any collating element defined in the locale, including single-character and multicharacter elements. 
						   The NLS_SORT initialization parameter determines supported collation elements.This operator lets you use a multicharacter collating 
						   element in cases where only one character is otherwise allowed. For example, you can ensure that the collating element ch, 
						   when defined in a locale such as Traditional Spanish, is treated as one character in operations that depend on the ordering of 
						   characters.
		* Example       => The expression [[.ch.]] searches for the collating element ch and matches ch in string chabc, but does not match cdefg. 
		                   The expression [a-[.ch.]] specifies the range a to ch.

	a1)Syntax => [=character=]
		* Operator_Name => POSIX Character Equivalence Class
		* Description   => Matches all characters that are members of the same character equivalence class in the current locale as the specified character.
                           The character equivalence class must occur within a character list, so the character equivalence class is always nested within 
						   the brackets for the character list in the regular expression.
                           Usage of character equivalents depends on how canonical rules are defined for your database locale. See Oracle Database 
						   Globalization Support Guide for more information about linguistic sorting and string searching.
		* Example       => The expression [[=n=]] searches for characters equivalent to n in a Spanish locale. It matches both N and ñ in the string El Niño.

5. PERL-Influenced Extensions to POSIX Regular Expression Standard?
    PERL-influenced metacharacters supported in Oracle Database regular expression functions and conditions. These metacharacters are not in the POSIX standard,
    but are common at least partly due to the popularity of PERL. PERL character class matching is based on the locale model of the operating system, whereas 
    Oracle Database regular expressions are based on the language-specific data of the database. In general, a regular expression involving locale data 
    cannot be expected to produce the same results between PERL and Oracle Database.

6. PERL-Influenced Extensions in Oracle Database Regular Expressions?
	a2) Regular Expression => \d
		* Matches          => A digit character. It is equivalent to the POSIX class [[:digit:]]. 
		* Example          => The expression ^\(\d{3}\) \d{3}-\d{4}$ matches (650) 555-0100 but does not match 650-555-0100.

	a2) Regular Expression => \D
		* Matches          => A nondigit character. It is equivalent to the POSIX class [^[:digit:]]. 
		* Example          => The expression \w\d\D matches b2b and b2_ but does not match b22.

	a2) Regular Expression => \w
		* Matches          => A word character, which is defined as an alphanumeric or underscore (_) character. It is equivalent to the 
		                      POSIX class [[:alnum:]_]. If you do not want to include the underscore character, you can use the POSIX class [[:alnum:]]. 
		* Example          => The expression \w+@\w+(\.\w+)+ matches the string jdoe@company.co.uk but not the string jdoe@company.

	a2) Regular Expression => \W
		* Matches          => A nonword character. It is equivalent to the POSIX class [^[:alnum:]_]. 
		* Example          => The expression \w+\W\s\w+ matches the string to: bill but not the string to bill.

	a2) Regular Expression => \s
		* Matches          => A whitespace character. It is equivalent to the POSIX class [[:space:]]. 
		* Example          => The expression \(\w\s\w\s\) matches the string (a b ) but not the string (ab).

	a2) Regular Expression => \S
		* Matches          => A nonwhitespace character. It is equivalent to the POSIX class [^[:space:]]. 
		* Example          => The expression \(\w\S\w\S\) matches the string (abde) but not the string (a b d e).

	a2) Regular Expression => \A
		* Matches          => Only at the beginning of a string. In multi-line mode, that is, when embedded newline characters in a string are considered 
		                      the termination of a line, \A does not match the beginning of each line. 
		* Example          => The expression \AL matches only the first L character in the string Line1\nLine2\n, regardless of whether the search is in 
		                      single-line or multi-line mode.

	a2) Regular Expression => \Z
		* Matches          => Only at the end of string or before a newline ending a string. In multi-line mode, that is, when embedded newline characters 
		                      in a string are considered the termination of a line, \Z does not match the end of each line. 
		* Example          => In the expression \s\Z, the \s matches the last space in the string L i n e \n, regardless of whether the search is in 
		                      single-line or multi-line mode.

	a2) Regular Expression => \z
		* Matches          => Only at the end of a string. 
		* Example          => In the expression \s\z, the \s matches the newline in the string L i n e \n, regardless of whether the search is in single-line 
		                      or multi-line mode.

	a2) Regular Expression => *?
		* Matches          => The preceding pattern element 0 or more times ("nongreedy"). This quantifier matches the empty string whenever possible. 
		* Example          => The expression \w*?x\w is "nongreedy" and so matches abxc in the string abxcxd. The expression \w*x\w is "greedy" and so matches 
		                      abxcxd in the string abxcxd. The expression \w*?x\w also matches the string xa.

	a2) Regular Expression => +?
		* Matches          => The preceding pattern element 1 or more times ("nongreedy"). 
		* Example          => The expression \w+?x\w is "nongreedy" and so matches abxc in the string abxcxd. The expression \w+x\w is "greedy" and so matches 
		                      abxcxd in the string abxcxd. The expression \w+?x\w does not match the string xa, but does match the string axa.

	a2) Regular Expression => ??
		* Matches          => The preceding pattern element 0 or 1 time ("nongreedy"). This quantifier matches the empty string whenever possible. 
		* Example          => The expression a??aa is "nongreedy" and matches aa in the string aaaa. The expression a?aa is "greedy" and so matches aaa in the 
		                      string aaaa.

	a2) Regular Expression => {n}?
		* Matches          => The preceding pattern element exactly n times ("nongreedy"). In this case {n}? is equivalent to {n}.
		* Example          => The expression (a|aa){2}? matches aa in the string aaaa.

	a2) Regular Expression => {n,}?
		* Matches          => The preceding pattern element at least n times ("nongreedy").
		* Example          => The expression a{2,}? is "nongreedy" and matches aa in the string aaaaa. The expression a{2,} is "greedy" and so matches aaaaa.

	a2) Regular Expression => {n,m}?
		* Matches          => At least n but not more than m times ("nongreedy"). {0,m}? matches the empty string whenever possible.
		* Example          => The expression a{2,4}? is "nongreedy" and matches aa in the string aaaaa. The expression a{2,4} is "greedy" and so matches aaaa.

7. What are the Oracle Regular Expression Pattern Matching?
    The Oracle Database regular expression functions and conditions support the pattern matching modifiers.

8. Different Types of Oracle Regular Expression Pattern Matching?
	a3) Mod => i
		* Description => Specifies case-insensitive matching.
		* Example     => The following regular expression returns AbCd:
		                 REGEXP_SUBSTR('AbCd', 'abcd', 1, 1, 'i')
	a3) Mod => c
		* Description => Specifies case-sensitive matching.
		* Example     => The following regular expression fails to match:
						 REGEXP_SUBSTR('AbCd', 'abcd', 1, 1, 'c')
	a3) Mod => n
		* Description => Allows the period (.), which by default does not match newlines, to match the newline character.
		* Example     => The following regular expression matches the string only because the n flag is specified:
					     REGEXP_SUBSTR('a'||CHR(10)||'d', 'a.d', 1, 1, 'n')
	a3) Mod => m
		* Description => Performs the search in multi-line mode. The metacharacter ^ and $ signify the start and end, respectively, of any line anywhere in 
		                 the source string, rather than only at the start or end of the entire source string.
		* Example     => The following regular expression returns ac:
						 REGEXP_SUBSTR('ab'||CHR(10)||'ac', '^a.', 1, 2, 'm')

	a3) Mod => x
		* Description => Ignores whitespace characters in the regular expression. By default, whitespace characters match themselves.
		* Example     => The following regular expression returns abcd:
						 REGEXP_SUBSTR('abcd', 'a b c d', 1, 1, 'x')

9. Types of SQL Regular Expression Functions?
 		a1) REGEXP_COUNT
		a2) REGEXP_LIKE
		a3) REGEXP_SUBSTR
		a4) REGEXP_INSTR
		a5) REGEXP_REPLACE

10. Examples:
    --*************************************************************--
    a1) REGEXP_COUNT:
	--*************************************************************--
    -- How evey count of comma in the given string
    SELECT
          REGEXP_COUNT('105,201,2,2,23,44,',',')
    FROM
         dual;
    
    -- The parameter as 13 defined the string length where I have to find the commas --
    SELECT
          REGEXP_COUNT('105,201,2,2,23,44,',',',13)
    FROM
         dual;
    
    -- We do not need to add REGEXP_COUNT in GROUP BY because the REGEXP_COUNT has performed operation for the single row not for multiple rows. 
    -- Don't do like aggregate function COUNT.
    SELECT
         employee_id,
         REGEXP_COUNT(first_name,'a')
    FROM
         hr.employees;

    --**************************************************************--
	a2)REGEXP_LIKE:
	--**************************************************************--
    Using a Constraint to Enforce a Phone Number Format
    Regular expressions are useful for enforcing constraints. For example, suppose that you want to ensure that phone numbers are entered into 
	the database in a standard format.To creates a contacts table and adds a CHECK constraint to the p_number column to enforce the following format mask:
    As: (XXX) XX-XXXXXXXX i.e. Enforcing a Phone Number Format with Regular Expressions
    
    DROP TABLE contacts PURGE;
    CREATE TABLE contacts
    (
	  l_name    VARCHAR2(30),
      p_number  VARCHAR2(30)
      CONSTRAINT c_contacts_pnf CHECK (REGEXP_LIKE(p_number, '^\(\d{5}\) \d{2}-\d{8}$'))
    );
 
    INSERT INTO contacts (l_name,p_number) 
	SELECT 'Devesh' l_name, '(00977) 98-41435006' p_number from dual;
    
    -- a{m} : Match 'a' at least m times.
    SELECT
          employee_id,
          last_name,
          job_id,
          salary
    FROM
          hr.employees
    WHERE
          REGEXP_LIKE(last_name,'l{2}');
    
    -- . Match any character
    SELECT
          employee_id,
          last_name,
          job_id,
          salary
    FROM
          hr.employees
    WHERE
          REGEXP_LIKE(last_name,'..ss');
    
	-- [hew] Matching Pattern
    SELECT
          employee_id,
          last_name,
          job_id,
          salary
    FROM
          hr.employees
    WHERE
          REGEXP_LIKE(last_name,'[hew]');

    -- A?b : the apperiance of A (before ?)must as leats 1 or 0 times and the character after ? is remain same.
    SELECT
          employee_id,
          last_name,
          job_id,
          salary
    FROM
          hr.employees
    WHERE
          regexp_like(last_name,'^A?b')
    
    -- * : Matches zero or more occurrences of the preceding subexpression
    -- To fetch the data from the hr.employees table having at least  1 'e' character in last_name column and can be more than 1 e.  
    SELECT
          employee_id,
          last_name,
          job_id,
          salary
    FROM
          hr.employees
    WHERE
          REGEXP_LIKE(last_name,'e*');
    
	--  +  : Matches one or more occurrences of the preceding subexpression.
    -- To fetch the data from the hr.employees table whose last_name column must have at least 1 apperence of a 
    SELECT
          employee_id,
          last_name,
          job_id,
          salary
    FROM
          hr.employees
    WHERE
          REGEXP_LIKE(last_name,'a+');
    
	-- a|b  : '|' behaves as OR operator 
    -- To fetch the data form the hr.employees table whose last_name column containing either of 2 character 'a' OR 'b'.    
    SELECT
          employee_id,
          last_name,
          job_id,
          salary
    FROM
          hr.employees
    WHERE
          REGEXP_LIKE(last_name,'a|b');

    -- a{m} : Matches exactly m occurrences of the preceding subexpression
    -- To fetch the data from the hr.employees table having 2 times occurance of the 'a' character on last_name column    
    SELECT
          employee_id,
          last_name,
          job_id,
          salary
    FROM
          hr.employees
    WHERE
          REGEXP_LIKE(last_name,'a{2}');
    
    -- a{m,}  :  Matches at least m occurrences of the preceding subexpression
    -- To fetch the data from the hr.employees table where the last_name consist of at leat 2 times occurance of 'l' character.     
    SELECT
          employee_id,
          last_name,
          job_id,
          salary
    FROM
          hr.employees
    WHERE
          REGEXP_LIKE(last_name,'l{2,}');
    
	-- {m,n}  :  Matches at least m, but not more than n occurrences of the preceding subexpression
    -- To fetch the rows from the hr.employees table where last_name must consist of  character '2' at least 2 times and not more than 3 times     
    SELECT
          employee_id,
          last_name,
          job_id,
          salary
    FROM
          hr.employees
    WHERE
          REGEXP_LIKE(last_name,'l{1,2}');
    
    -- (...) : Treat expression ... as a unit. Thesubexpression can be a string of literals or a complex expression containing operators.
    -- To fetch all the rows from the hr.employees table.     
    SELECT
          employee_id,
          last_name,
          job_id,
          salary
    FROM
          hr.employees
    WHERE
          REGEXP_LIKE(last_name,'(...)');
    
    -- Let us play with virtual table having
    WITH tbl_like AS (SELECT 'A__A' col1 FROM dual UNION ALL
                      SELECT 'A__B' col1 FROM dual)
    SELECT * FROM tbl_like;
    
    -- While using normal LIKE comparision operator we need to define ESCAPE identifier either( \ OR /)
    WITH tbl_like AS (SELECT 'A__A' col1 FROM dual UNION ALL
                      SELECT 'A__B' col1 FROM dual)
    SELECT * FROM tbl_like
    WHERE
        col1 LIKE 'A/__A' ESCAPE '/';
    
    --In case of regural expression LIKE we need not need to define the ESCAPE identifier we need just backslash(\) to escape the metacharacter used in regular expression like.
    WITH tbl_like AS (SELECT 'A__A' col1 FROM dual UNION ALL
                      SELECT 'A__B' col1 FROM dual)
    SELECT * FROM tbl_like
    WHERE
        REGEXP_LIKE(col1, 'A\__B') ;
    
	-- We do not need to use backslash(\) for ' _ ' because '_' not a metacharacter of the regexp_like
    SELECT
         employee_id,
         last_name,
         job_id
    FROM
         hr.employees
    WHERE
         REGEXP_LIKE(job_id,'^IT\_');
    
    SELECT
         employee_id,
         last_name,
         job_id
    FROM
         hr.employees
    MINUS
    SELECT
         employee_id,
         last_name,
         job_id
    FROM
         hr.employees
    WHERE
         REGEXP_LIKE(job_id,'^IT_');

    -- ^  :   Match the subsequent expression only when it occurs at the beginning of a line.
    -- To fetchn the rows of hr.employees where the last_name starts with 'O' character.
    SELECT
          employee_id,
          last_name,
          job_id,
          salary
    FROM
          hr.employees
    WHERE
          regexp_like(last_name,'^O');
    
    --  $  :  Match the preceding expression only when it occurs at the end of a line.
    -- To fetch the rows from the hr.employees table where last_name column values ends as 'all' character.
    SELECT
          employee_id,
          last_name,
          job_id,
          salary
    FROM
          hr.employees
    WHERE
          regexp_like(last_name,'all$');

    DROP TABLE tab_regexp PURGE;
    CREATE TABLE tab_regexp 
    AS 
    SELECT 'AAAAAAAAAAAAA' DATA1 FROM DUAL UNION ALL 
    SELECT 'BBBBB25022014' DATA1 FROM DUAL UNION ALL 
    SELECT 'BBBBB26022013' DATA1 FROM DUAL UNION ALL 
    SELECT '23022012BBBBB' DATA1 FROM DUAL UNION ALL 
    SELECT '22022011BBBBB' DATA1 FROM DUAL UNION ALL 
    SELECT '23022012BBBB_' DATA1 FROM DUAL UNION ALL 
    SELECT 'BBBBB12032010' DATA1 FROM DUAL UNION ALL 
    SELECT '02031999BBBBB' DATA1 FROM DUAL UNION ALL 
    SELECT 'BB_NNNNNNNNNN' DATA1 FROM DUAL UNION ALL 
    SELECT 'BBB_BBBBBBBBB' DATA1 FROM DUAL UNION ALL 
    SELECT '_FFFFFFFFFFFF' DATA1 FROM DUAL UNION ALL 
    SELECT 'BBBBBBBBBVVVV' DATA1 FROM DUAL UNION ALL 
    SELECT 'BB_BB_GGGGGGG' DATA1 FROM DUAL UNION ALL 
    SELECT '1111234566666' DATA1 FROM DUAL UNION ALL 
    SELECT '279-901' DATA1 FROM DUAL;
   
    -- To fetch the data that start with digits and end alfanumeric charters 
    SELECT 
         DATA1 
    FROM 
         tab_regexp 
    WHERE 
         REGEXP_LIKE(data1,'[[:digit:]][[:alpha:]][[:alnum:]]'); 
    
    -- To fetch all the data that except start with wild card
    SELECT 
         DATA1 
    FROM 
         tab_regexp
    WHERE 
         REGEXP_LIKE(data1,'^[[:alnum:]]'); 
    
    -- To fetch all the data
    SELECT 
         DATA1 
    FROM 
         tab_regexp
    WHERE 
         REGEXP_LIKE(data1,'[[:alnum:]]');
    
    -- To fetch all the data that starts from digits
    SELECT 
         DATA1 
    FROM 
         tab_regexp 
    WHERE 
         REGEXP_LIKE(data1,'^[[:digit:]]'); 
    
    -- To fetch all the data that starts from alfabetical charters
    SELECT 
         DATA1 
    FROM 
         tab_regexp 
    WHERE 
         REGEXP_LIKE(data1,'^[[:alpha:]]'); 
    
    -- To fetch all the data that includes from albets and digits
    SELECT 
         DATA1 
    FROM 
         tab_regexp 
    WHERE 
         REGEXP_LIKE(data1,'[[:alpha:]][[:digit:]]'); 
                
    -- To fetch the data for any charecters but ends with digits
    SELECT 
         DATA1 
    FROM 
         tab_regexp
    WHERE 
         REGEXP_LIKE(data1,'^*[[:digit:]]$'); 
    
    -- To fetch the data for any 5 charecters but ends with digits that digits must have 8 number of digits
    SELECT 
         DATA1 
    FROM 
         tab_regexp
    WHERE 
         REGEXP_LIKE(data1,'^.....[[:digit:]]{8}'); 
    
    -- To fetch the data for start with digits and also end with digits
    SELECT 
         DATA1 
    FROM 
         tab_regexp 
    WHERE 
         REGEXP_LIKE(data1,'^[[:digit:]]+$'); 
    
    -- To fetch the data for that 6 digits with in the middle dash charecter should be present there
    SELECT 
         DATA1 
    FROM 
         tab_regexp 
    WHERE 
         REGEXP_LIKE(data1,'[0-9][0-9][0-9]-[0-9][0-9][0-9]'); 
    
    -- To fetch the data for that 6 smoll alfabetical checters with in the middle dash charecter should be present there
    INSERT INTO tab_regexp VALUES ('aaa-aaa');
    SELECT 
         DATA1 
    FROM 
         tab_regexp 
    WHERE 
         REGEXP_LIKE(data1,'[a-z][a-z][a-z]-[a-z][a-z][a-z]');
    
    -- To fetch the data for that 6 upper alfabetical checters with in the middle dash charecter should be present there
    INSERT INTO tab_regexp VALUES ('AAA-AAA');
    SELECT 
         DATA1 
    FROM 
         tab_regexp 
    WHERE 
         REGEXP_LIKE(data1,'[A-Z][A-Z][A-Z]-[A-Z][A-Z][A-Z]');
	 
    --*********************************************************--
    a3)REGEXP_SUBSTR
    --*********************************************************--
    --Syntax:
    REGEXP_SUBSTR (source_string,pattern
                   [,POSITION
                      [,occurance
                         [,match_parameter
                         ]
                      ]
                   ]
                  );

    /*
	  SOURCE_STRING : is a character expression that serves as the search value.
      It is commonly a character column and can be of any of the datatypes CHAR, VARCHAR2, NCHAR, NVARCHAR2, CLOB, or NCLOB.
      
      PATTERN  : It is usually a text literal and can be of any of the datatypes CHAR, VARCHAR2, NCHAR, or NVARCHAR2.
       It can contain up to 512 bytes. If the datatype of pattern is different from the datatype of source_string,
      Oracle Database converts pattern to the datatype of source_string
      
      POSITION :  is a positive integer indicating the character of source_string where Oracle should begin the search.
      The default is 1, meaning that Oracle begins the search at the first character of source_string.
      
      OCCURANCE :  is a positive integer indicating which occurrence of pattern in source_string Oracle should search for.
      The default is 1, meaning that Oracle searches for the first occurrence of pattern.
      
      MATCH_PARAMETER : is a text literal that lets you change the default matching behavior of the function.
      You can specify one or more of the following values for match_parameter:
      i case insensitive
    */
	
	-- use of i and c case insensitive and case sensitive resectivly
    -- data fetch the 2 occurence of simal data using  
	SELECT
         REGEXP_SUBSTR('de vesh vesh','vesh',1,2,'i') AS "case-insensitive",
         REGEXP_SUBSTR('de vesh vesh','vesh',1,2,'c') AS "case-sensitive"
    FROM
         dual;

    SELECT
         REGEXP_SUBSTR('DevesH','eve',1,1,'i')
    FROM
         dual;

    SELECT
         REGEXP_SUBSTR('DevesH','eve',1,1,'c')
    FROM
         dual;
    
    -- n :allows the period (.), which is the match-any-character character, to match the newline character.
    -- If you omit this parameter, the period does not match the newline character.
    CREATE TABLE tbl_substr
    (
      col1 VARCHAR2(10)
    );
    
	-- To data with new line 
    INSERT INTO tbl_substr(col1) VALUES ('a');
    INSERT INTO tbl_substr(col1) 
	VALUES ('a
    b');
    INSERT INTO tbl_substr(col1) 
	VALUES ('a
    b
    c');
    
	INSERT INTO tbl_substr(col1) 
	SELECT 
	     'a'||CHR(10)||'b'||CHR(10)||'c'||CHR(10)||'d' col1 
    FROM 
	    dual;

    SELECT
         REGEXP_SUBSTR(col1,'a',1,1,'n') "a",
         REGEXP_SUBSTR(col1,'a.',1,1,'n') "a.",
         REGEXP_SUBSTR(col1,'a.b',1,1,'n') "a.b",
         REGEXP_SUBSTR(col1,'a...c',1,1,'n') "a...c"
    FROM
         tbl_substr;
    
    /*
      m :  treats the source string as multiple lines. Oracle interprets ^ and $ as the start and end, respectively,
      of any line anywhere in the source string, rather than only at the start or end of the entire source string.
      If you omit this parameter, Oracle treats the source string as a single line.
    */
	
    INSERT INTO tbl_substr(col1) VALUES ('a');
	INSERT INTO tbl_substr(col1) 
	SELECT 'aa'||CHR(10)||'b' col1 FROM dual UNION ALL
	SELECT 'a'||CHR(10)||'b'||CHR(10)||'c'||CHR(10)||'d' col1 FROM dual;
    
    -- To find the a from new line
	SELECT
         col1,
         REGEXP_SUBSTR(col1,'^a$',1,1,'m')
    FROM
         tbl_substr;
    
    --x : ignores whitespace characters. By default, whitespace characters match themselves.
    SELECT
         REGEXP_SUBSTR('oracle','o   r   a',1,1),
         REGEXP_SUBSTR('oracle','o   r   a',1,1,'x')
    FROM
         dual;
    
	--**********************************************************************--
    a4)REGEXP_INSTR
    --**********************************************************************--
    /*
	  REGEXP_INSTR extends the functionality of the INSTR function by letting you search a string for a regular expression pattern.
      The function evaluates strings using characters as defined by the input character set.
      It returns an integer indicating the beginning or ending position of the matched substring, depending on the value of the return_option argument.
      If no match is found, the function returns 0.
    */
	
    --Syntax:
    REGEXP_INSTR (source_char,pattern
                  [,position
                    [,occurrence
                       [,return_option
                          [,match_parameter]
                       ]
                    ]
                  ]
                 );
    
    /*
	  SOURCE_CHAR : is a character expression that serves as the search value.
      It is commonly a character column and can be of any of the datatypes CHAR, VARCHAR2, NCHAR, NVARCHAR2, CLOB, or NCLOB.
      
      PATTERN : is the regular expression. It is usually a text literal and can be of any of the datatypes CHAR, VARCHAR2, NCHAR, or NVARCHAR2
      If the datatype of pattern is different from the datatype of source_char, Oracle Database converts pattern to the datatype of source_char.
      
      POSITION : is a positive integer indicating the character of source_char where Oracle should begin the search.
      The default is 1, meaning that Oracle begins the search at the first character of source_char.
      
      OCCURRENCE :   is a positive integer indicating which occurrence of pattern in source_char Oracle should search for.
      The default is 1, meaning that Oracle searches for the first occurrence of pattern.
      
      RETURN_OPTION :lets you specify what Oracle should return in relation to the occurrence:
      
      If you specify 0, then Oracle returns the position of the first character of the occurrence. This is the default.
      
      If you specify 1, then Oracle returns the position of the character following the occurrence.
      
      MATCH_PARAMETER : is a text literal that lets you change the default matching behavior of the function.
      You can specify one or more of the following values for match_parameter:

      'i' specifies case-insensitive matching.
      
      'c' specifies case-sensitive matching.
      
      'n' allows the period (.), which is the match-any-character character, to match the newline character.
      If you omit this parameter, the period does not match the newline character.
      
      'm' treats the source string as multiple lines. Oracle interprets ^ and $ as the start and end, respectively, of any line anywhere in the source string, rather than only at the start or end of the entire source string.
      If you omit this parameter, Oracle treats the source string as a single line.
      
      'x' ignores whitespace characters. By default, whitespace characters match themselves.
    */

	-- 'i' specifies case-insensitive matching
    SELECT
         REGEXP_INSTR('parameter','a',1,2,0,'i')
    FROM
         dual;
    
    CREATE TABLE tbl_instr
    AS
      SELECT 'source_string_19022016'  col1 FROM dual UNION ALL
      SELECT 'case_sensitive_07052016' col1 FROM dual UNION ALL
      SELECT 'NLS_PARAMETER_07052016'  col1 FROM dual;

    SELECT
         SubStr(col1,1,InStr(col1,'_',1)-1) "First Part"
    FROM
         tbl_instr;
    
    SELECT
         SubStr(col1,InStr(col1,'_',1)+1,(REGEXP_INSTR(col1,'_',1,2,0,'i'))-REGEXP_INSTR(col1,'_',1,1,0,'i')-1) "Middle Part"
    FROM
         tbl_instr;
    
    SELECT
          SubStr(col1,regexp_instr(col1, '_' ,1 ,2 ,1,'i'),8) "Date Part"
    FROM
          tbl_instr;
    
    --INSERT a multiline string in Oracle table using tha ASCII value chr(10) which has (enter space character)
    INSERT INTO tbl_instr(col1) VALUES('s'||CHR(10)||' s'||Chr(10)||'p'||Chr(10)||'p'||Chr(10)||'a');
    
    SELECT col1,
          REGEXP_INSTR(col1, '_' ,1 ,2 ,1,'i') reg_instr,
          SubStr(col1,REGEXP_INSTR(col1, '_' ,1 ,2 ,1,'i'),8) normal_substr,
          REGEXP_REPLACE(SubStr(col1,REGEXP_INSTR(col1, '_' ,1 ,2 ,1,'i'),8),'([[:digit:]]{2})\.([[:digit:]]{2})\.([[:digit:]]{4})','(\1 \2-\3)') "REGEXP_REPLACE" ,
          REGEXP_REPLACE('19022016','([[:digit:]]{2})([[:digit:]]{2})([[:digit:]]{4})','\1-\2-\3') asyourcode,
          REGEXP_REPLACE('19.02.2016','([[:digit:]]{2})\.([[:digit:]]{2})\.([[:digit:]]{4})','(\1 -\2 -\3)') thatworkfor,
          REGEXP_REPLACE('19.02.2016','([[:digit:]]{2})\.([[:digit:]]{2})\.([[:digit:]]{4})','(\2 -\1 -\3)') diffway,
          REGEXP_REPLACE('19.02.2016','([[:digit:]]{2})\.([[:digit:]]{2})\.([[:digit:]]{4})','(\1)') diffway1
    FROM
          tbl_instr;

	--***************************************************--
	a5) REGEXP_REPLACE:
    --***************************************************--
    /*
      Searches for a pattern in a character column and replaces each
      occurrence of that pattern with the specified string.
      The following function call puts a space after each character in
      the country_namecolumn:
      REGEXP_REPLACE(country_name, '(.)', '\1 ')
    */
    --Syntax:
    REGEXP_REPLACE(source_char, pattern
                   [, replace_string
                      [, position
                         [, occurrence
                            [, match_parameter ]
                         ]
                      ]
                   ]
                  );

	The script in Example creates a table famous_people , populates it with names in different formats, and uses a query that repositions names that are 
    in the format "first middle last" to the format "last, first middle". It ignores names not in the format "first middle last". 
    
	DROP TABLE famous_people PURGE;
    CREATE TABLE famous_people 
    (
      names VARCHAR2(50)
    );

    INSERT INTO famous_people (names)
    SELECT 'Shrivastav Devesh Kumar' names FROM dual UNION ALL
    SELECT 'Pantha Suman' names FROM dual UNION ALL
    SELECT 'Ranabhat Saroj' names FROM dual UNION ALL
    SELECT 'Kumar Shrivastav Devesh' names FROM dual; 

    SELECT 
         names "names",
         REGEXP_REPLACE(names, '^(\S+)\s(\S+)\s(\S+)$', '\3, \1 \2') AS "names after regexp"
    FROM 
         famous_people;

    names                   names after regexp
    ----------------------- -------------------------     
    Shrivastav Devesh Kumar Kumar, Shrivastav Devesh
    Pantha Suman            Pantha Suman            
    Ranabhat Saroj          Ranabhat Saroj          
    Kumar Shrivastav Devesh Devesh, Kumar Shrivastav
	
    /*  
	  SOURCE_CHAR : is a character expression that serves as the search value.
      It is commonly a character column and can be of any of the datatypes CHAR, VARCHAR2, NCHAR, NVARCHAR2, CLOB, or NCLOB.
      
      PATTERN : is the regular expression. It is usually a text literal and can be of any of the datatypes CHAR, VARCHAR2, NCHAR, or NVARCHAR2
       If the datatype of pattern is different from the datatype of source_char, Oracle Database converts pattern to the datatype of source_char.
      
      REPLACE_STRING :  can be of any of the datatypes CHAR, VARCHAR2, NCHAR, NVARCHAR2, CLOB, or NCLOB.
      If replace_string is a CLOB or NCLOB, then Oracle truncates replace_string to 32K.
       The replace_string can contain up to 500 backreferences to subexpressions in the form \n, where n is a number from 1 to 9.
      If n is the backslash character in replace_string, then you must precede it with the escape character (\\).
      
      POSITION :  is a positive integer indicating the character of source_char where Oracle should begin the search.
      The default is 1, meaning that Oracle begins the search at the first character of source_char.
      
      OCCURRENCE : is a nonnegative integer indicating the occurrence of the replace operation:
      
      you specify 0, then Oracle replaces all occurrences of the match.
      you specify a positive integer n, then Oracle replaces the nth occurrence.
          
      MATCH_PARAMETER : is a text literal that lets you change the default matching behavior of the function.
      You can specify one or more of the following values for match_parameter:
      
      ' specifies case-insensitive matching.
      
      ' specifies case-sensitive matching.
      
      ' allows the period (.), which is the match-any-character character, to match the newline character. If you omit this parameter, the period does not match the newline character.
      
      ' treats the source string as multiple lines. Oracle interprets ^ and $ as the start and end, respectively, of any line anywhere in the source string, rather than only at the start or end of the entire source string.
      If you omit this parameter, Oracle treats the source string as a single line.
      
      ' ignores whitespace characters. By default, whitespace characters match themselves.
    */

    -- Fetch the date of from given file name CosmosData_file_22.01.2016.csv as per your requirments  (play with Bind variable)
    SELECT
          REGEXP_REPLACE(SubStr(col1,REGEXP_INSTR(col1, '_' ,1 ,2 ,1,'i'),10),'([[:digit:]]{2})\.([[:digit:]]{2})\.([[:digit:]]{4})','(\1 \2-\3)') "REGEXP_REPLACE"
    FROM
          (SELECT 'CosmosData_file_22.01.2016.csv' col1 FROM dual );
    
    REGEXP_REPLACE
    --------------
    (22 01-2016)  

    -- To fetch all data of hr.employees as '%_%' using LIKE chadrecter eveipulation function
    SELECT
         REGEXP_REPLACE(first_name,'(.)','\1')
    FROM
         hr.employees;
    
    -- To play with bind variable using single bind variable
    SELECT
         REGEXP_REPLACE('nepal','([[:alpha:]]{2})','(\1')
    FROM
         dual;

SELECT
     lvl1id,
     CASE
        WHEN regexp_replace(regexp_replace(lvl1id,'( ){2,}',''),'(^\S*)( ){1,}(\S*)','\2') = ' '
        THEN SUBSTR(regexp_replace(regexp_replace(lvl1id,'( ){2,}',' '),'(^\S)( ){1,}(\S*)','\1'),1,1)||SubStr(regexp_replace(regexp_replace(lvl1id,'( ){2,}',' '),'(^\S)( ){1,}(\S*)','\3'),1,1)
        WHEN regexp_replace(regexp_replace(lvl1id,'( ){2,}',' '),'(^\S)( ){1,}(\S)( ){1,}(\S*)','\2') = ' '
        THEN SUBSTR(regexp_replace(regexp_replace(lvl1id,'( ){2,}',' '),'(^\S)( ){1,}(\S)( ){1,}(\S*)','\1'),1,1)||SubStr(regexp_replace(regexp_replace(lvl1id,'( ){2,}',' '),'(^\S)( ){1,}(\S)( ){1,}(\S*)','\3'),1,1)||SubStr(regexp_replace(regexp_replace(lvl1id,'( ){2,}',' '),'(^\S)( ){1,}(\S)( ){1,}(\S*)','\5'),1,1)
     ELSE
        lvl1id
     END lvl1id
FROM (select 'PlanTypeCode'   lvl1id from dual union all
      select 'AETNA'          lvl1id from dual union all
      select 'BLUE ADVANTAGE' lvl1id from dual union all
      select 'HMOI'           lvl1id from dual union ALL
      select 'BLUE PRECISION' lvl1id from dual union all
      select 'NPBM ABM PMD'   lvl1id from dual union all
      select 'RPAYOR'         lvl1id from dual);
	  
-------------------------------------------------------------------------	  

SELECT
     SUM(number_data)                                    number_data,
     listagg(string_data,'') WITHIN GROUP(ORDER BY sn)   string_data,
     listagg(wildcard_data,'') WITHIN GROUP(ORDER BY sn) wildcard_data
FROM (
      SELECT
           ROWNUM sn,
           regexp_substr(string,'[[:digit:]]+',1,LEVEL) number_data,
           regexp_substr(string,'[[:alpha:]]+',1,LEVEL) string_data,
           regexp_substr(string,'(\W)',1,LEVEL)         wildcard_data
      FROM (
            SELECT
                 'a24iu5e1hg1uo9@^$(5dhjf$^%|5g!1g#e1' string
            FROM dual
           )
      CONNECT BY LEVEL <= LENGTH(string)-LENGTH(regexp_replace(string,'[[:digit:]]'))+1
     );

SELECT col1,
      REGEXP_INSTR(col1, '_' ,1 ,2 ,1,'i') reg_instr,
      SubStr(col1,REGEXP_INSTR(col1, '_' ,1 ,2 ,1,'i'),8) normal_substr,
      REGEXP_REPLACE(SubStr(col1,REGEXP_INSTR(col1, '_' ,1 ,2 ,1,'i'),8),'([[:digit:]]{2})\.([[:digit:]]{2})\.([[:digit:]]{4})','(\1 \2-\3)') "REGEXP_REPLACE",
      REGEXP_REPLACE('19022016','([[:digit:]]{2})([[:digit:]]{2})([[:digit:]]{4})','\1-\2-\3') asyourcode,
      REGEXP_REPLACE('19.02.2016','([[:digit:]]{2})\.([[:digit:]]{2})\.([[:digit:]]{4})','(\1 -\2 -\3)') thatworkfor,
      REGEXP_REPLACE('19.02.2016','([[:digit:]]{2})\.([[:digit:]]{2})\.([[:digit:]]{4})','(\2 -\1 -\3)') diffway,
      REGEXP_REPLACE('19.02.2016','([[:digit:]]{2})\.([[:digit:]]{2})\.([[:digit:]]{4})','(\1)') diffway1
FROM
      tbl_instr;

SELECT * FROM tbl_instr;

SELECT regexp_replace('98.41.182611','([[:digit:]]{2})\.([[:digit:]]{2})\.([[:digit:]]{4})','(\1 \2-\3)') reg FROM dual;

SELECT regexp_replace('9841182611','([[:digit:]]{2})([[:digit:]]{2})([[:digit:]]{4})','(\1 \2-\3)') reg FROM dual;

SELECT regexp_replace('9841182611','([[:digit:]]{2})([[:digit:]]{2})([[:digit:]]{4})','(\1-\2-\3)') reg FROM dual;

SELECT regexp_replace('9841182611','([[:digit:]]{2})([[:digit:]]{2})([[:digit:]]{4})','(\1)') reg FROM dual;


SELECT  regexp_replace(regexp_replace('DevesH pantha','( ){2,}',''),'(^\S*)( ){1,}(\S*)','\2') reg FROM dual;

SELECT SUBSTR(regexp_replace(regexp_replace('DevesH pantha','( ){2,}',' '),'(^\S)( ){1,}(\S*)','\1'),1,1)||SubStr(regexp_replace(regexp_replace('DevesH pantha','( ){2,}',' '),'(^\S*)( ){1,}(\S*)','\3'),1,1) reg FROM dual;

SELECT SubStr(regexp_replace('DevesH pantha', '((^\S))(( ){1,})((\S*))','\3'),1,1) reg FROM dual;


SELECT regexp_replace(regexp_replace('DevesH pantha','( ){2,}',' '), '(^\S)( ){1,}(\S*)','\5') reg FROM dual;


SELECT SUBSTR(regexp_replace(regexp_replace('DevesH k pantha','( ){2,}',' '),'(^\S)( ){1,}(\S)( ){1,}(\S*)','\1'),1,1) FROM dual;

SELECT SubStr(regexp_replace(regexp_replace('DevesH k pantha','( ){2,}',' '),'(^\S*)( ){1,}(\S)( ){1,}(\S*)','\3'),1,1) FROM dual;

SELECT SubStr(regexp_replace(regexp_replace('DevesH k pantha','( ){2,}',' '),'(^\S*)( ){1,}(\S)( ){1,}(\S*)','\5'),1,1) FROM dual




--ANYNOMOUS BLOCK TO ARRANGE THE STRING
DECLARE
    tbl_name     VARCHAR2(30) := 'tbl_word';
    col_name     VARCHAR2(30) := 'lvl1id';
    vblsql       VARCHAR2(32767);
    vblword      VARCHAR2(32767);
    vbl_trimword VARCHAR2(32767);
    TYPE crs     IS REF CURSOR;
    c1           crs;
BEGIN
      vblsql:= 'SELECT
                 '||col_name||',
                 CASE
                    WHEN regexp_replace(regexp_replace('||col_name||',''( ){2,}'','' ''),''(^\S*)( ){1,}(\S*)'',''\2'') = '' ''
                    THEN SUBSTR(regexp_replace(regexp_replace('||col_name||',''( ){2,}'','' ''),''(^\S)( ){1,}(\S*)'',''\1''),1,1)||SubStr(regexp_replace(regexp_replace('||col_name||',''( ){2,}'','' ''),''(^\S*)( ){1,}(\S*)'',''\3''),1,1)
                    WHEN regexp_replace(regexp_replace('||col_name||',''( ){2,}'','' ''),''(^\S*)( ){1,}(\S*)( ){1,}(\S*)'',''\2'') = '' ''
                    THEN SUBSTR(regexp_replace(regexp_replace('||col_name||',''( ){2,}'','' ''),''(^\S)( ){1,}(\S)( ){1,}(\S*)'',''\1''),1,1)||SubStr(regexp_replace(regexp_replace('||col_name||',''( ){2,}'','' ''),''(^\S*)( ){1,}(\S*)( ){1,}(\S*)'',''\3''),1,1)||SubStr(regexp_replace(regexp_replace('||col_name||',''( ){2,}'','' ''),''(^\S*)( ){1,}(\S*)( ){1,}(\S*)'',''\5''),1,1)
                 ELSE
                    '||col_name||'
                 END '||col_name||' FROM '||tbl_name||'';
     OPEN c1 FOR vblsql;
     LOOP
     FETCH c1 INTO vblword, vbl_trimword;
     EXIT WHEN c1%NOTFOUND;
     Dbms_Output.Put_Line('full string :  '||vblword||'  trim word :   '||vbl_trimword);
     END LOOP;
     CLOSE c1;
END;
/

--PROCEDURE
CREATE OR REPLACE PROCEDURE sp_word_arrange
(
 tbl_name     VARCHAR2,
 col_name     VARCHAR2
)
AS
  vblsql       VARCHAR2(32767);
  vblword      VARCHAR2(32767);
  vbl_trimword VARCHAR2(32767);
  TYPE crs     IS REF CURSOR;
  c1           crs;
BEGIN
    vblsql:= 'SELECT
                 '||col_name||',
                 CASE
                    WHEN regexp_replace(regexp_replace('||col_name||',''( ){2,}'','' ''),''(^\S*)( ){1,}(\S*)'',''\2'') = '' ''
                    THEN SUBSTR(regexp_replace(regexp_replace('||col_name||',''( ){2,}'','' ''),''(^\S)( ){1,}(\S*)'',''\1''),1,1)||SubStr(regexp_replace(regexp_replace('||col_name||',''( ){2,}'','' ''),''(^\S*)( ){1,}(\S*)'',''\3''),1,1)
                    WHEN regexp_replace(regexp_replace('||col_name||',''( ){2,}'','' ''),''(^\S*)( ){1,}(\S*)( ){1,}(\S*)'',''\2'') = '' ''
                    THEN SUBSTR(regexp_replace(regexp_replace('||col_name||',''( ){2,}'','' ''),''(^\S)( ){1,}(\S)( ){1,}(\S*)'',''\1''),1,1)||SubStr(regexp_replace(regexp_replace('||col_name||',''( ){2,}'','' ''),''(^\S*)( ){1,}(\S*)( ){1,}(\S*)'',''\3''),1,1)||SubStr(regexp_replace(regexp_replace('||col_name||',''( ){2,}'','' ''),''(^\S*)( ){1,}(\S*)( ){1,}(\S*)'',''\5''),1,1)
                 ELSE
                    '||col_name||'
                 END '||col_name||' FROM '||tbl_name||'';
     OPEN c1 FOR vblsql;
     LOOP
     FETCH c1 INTO vblword, vbl_trimword;
     EXIT WHEN c1%NOTFOUND;
     Dbms_Output.Put_Line('full string :  '||vblword||'  trim word :   '||vbl_trimword);
     END LOOP;
     CLOSE c1;
END sp_word_arrange;
/


EXEC sp_word_arrange('tbl_word','lvl1id');

WITH DATA
AS
(
 SELECT 'BKBJJK_JNUJNKJ_001' COL FROM DUAL UNION ALL
 SELECT 'BKBJJK_JNUJNKJ_009' COL FROM DUAL UNION ALL
 SELECT 'BKBJJK_JNUJNKJ_022' COL FROM DUAL UNION ALL
 SELECT 'BKBJJK_JNUJNKJ_099' COL FROM DUAL UNION ALL
 SELECT 'BKBJJK_JNUJNKJ_111' COL FROM DUAL UNION ALL
 SELECT 'BKBJJK_JNUJNKJ_999' COL FROM DUAL UNION ALL
 SELECT 'BKBJJK_JNUJNKJ_P001' COL FROM DUAL UNION ALL
 SELECT 'BKBJJK_JNUJNKJ_P009' COL FROM DUAL UNION ALL
 SELECT 'BKBJJK_JNUJNKJ_P022' COL FROM DUAL UNION ALL
 SELECT 'BKBJJK_JNUJNKJ_P099' COL FROM DUAL UNION ALL
 SELECT 'BKBJJK_JNUJNKJ_P011' COL FROM DUAL UNION ALL
 SELECT 'BKBJJK_JNUJNKJ_P999' COL FROM DUAL
)
SELECT regexp_replace(COL,'[0-9]'),Length(To_Number(REGEXP_SUBSTR(COL,'[0-9]+'))),To_Number(REGEXP_SUBSTR(COL,'[0-9]+'))+1,
       CASE 
          WHEN Length(To_Number(REGEXP_SUBSTR(COL,'[0-9]+'))) = 1 
          THEN CASE 
                  WHEN Length(TO_NUMBER(REGEXP_SUBSTR(COL,'[0-9]+'))+1) = 1 
                  THEN regexp_replace(COL,'[0-9]')||'00'||To_Char(TO_NUMBER(REGEXP_SUBSTR(COL,'[0-9]+'))+1)
                  ELSE regexp_replace(COL,'[0-9]')||'0'||To_Char(TO_NUMBER(REGEXP_SUBSTR(COL,'[0-9]+'))+1) END
          WHEN Length(To_Number(REGEXP_SUBSTR(COL,'[0-9]+'))) = 2 
          THEN CASE 
                  WHEN Length(TO_NUMBER(REGEXP_SUBSTR(COL,'[0-9]+'))+1) = 2 
                  THEN regexp_replace(COL,'[0-9]')||'0'||To_Char(TO_NUMBER(REGEXP_SUBSTR(COL,'[0-9]+'))+1)
                  ELSE regexp_replace(COL,'[0-9]')||To_Char(TO_NUMBER(REGEXP_SUBSTR(COL,'[0-9]+'))+1) END
          WHEN Length(To_Number(REGEXP_SUBSTR(COL,'[0-9]+'))) = 3 
          THEN CASE 
                  WHEN Length(TO_NUMBER(REGEXP_SUBSTR(COL,'[0-9]+'))+1) = 3 
                  THEN regexp_replace(COL,'[0-9]')||To_Char(TO_NUMBER(REGEXP_SUBSTR(COL,'[0-9]+'))+1) 
                  ELSE regexp_replace(COL,'[0-9]')||'0'||To_Char(TO_NUMBER(REGEXP_SUBSTR(COL,'[0-9]+'))+1) END
          END COL
FROM DATA;
