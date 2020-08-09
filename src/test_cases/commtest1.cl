
-- this is a line comment

(* --This is also a comment *)

*) --This is error

(* --This is a comment \\\*);

-- \n \t \b this is a comment
(*
 \\n \t \b this is also a comment
*)

(*
This is not a comment
)

--EOF in nested comments

(*
Only one '\* \)' is closed *)