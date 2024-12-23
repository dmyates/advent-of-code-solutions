% File reading
read_file(Stream, []):-
   at_end_of_stream(Stream), !.
read_file(Stream, [Line|Rest]):-
   read_line(Stream, Line),
   read_file(Stream, Rest).

read_line(Stream, Line):-
   get_code(Stream, Char),
   read_chars(Stream, Char, Chars),
   atom_codes(Line, Chars).

read_chars(_, 10, []):- !.  % newline
read_chars(_, -1, []):- !.  % end of file
read_chars(Stream, Char, [Char|Rest]):-
   get_code(Stream, NextChar),
   read_chars(Stream, NextChar, Rest).

% Rules & lists are separated by an empty line
split_on_empty([], [], []).
split_on_empty([''|Rest], [], Rest) :- !.
split_on_empty([Line|Rest], [Line|Rules], Lists) :-
   split_on_empty(Rest, Rules, Lists).

% Rule parsing
parse_rule(Rule, X, Y) :-
   once((
       atom_codes(Rule, Codes),
       append(LeftCodes, [124|RightCodes], Codes),
       number_codes(X, LeftCodes),
       number_codes(Y, RightCodes)
   )).

% List parsing
parse_list(ListStr, Numbers) :-
   atom_codes(ListStr, Codes),
   split_on_comma(Codes, NumStrs),
   maplist(number_codes, Numbers, NumStrs).

split_on_comma([], [[]]) :- !.
split_on_comma([44|Rest], [[]|Lists]) :- !, % 44 is ASCII for comma
   split_on_comma(Rest, Lists).
split_on_comma([Code|Rest], [[Code|Codes]|Lists]) :-
   split_on_comma(Rest, [Codes|Lists]).

% Core rules
precedes(X, Y, L):-
   (   memberchk(X, L),
       memberchk(Y, L) ->
       once((append(_, [X|Tail], L), memberchk(Y, Tail)))
   ;   true  % succeed if either X or Y is not in L
   ).


check_all_rules(Rules, List) :-
   \+ (member(Rule, Rules),
       parse_rule(Rule, X, Y),
       \+ precedes(X, Y, List)).

find_valid_lists(Rules, Lists, ValidLists, InvalidLists) :-
   findall(Numbers,
           (member(ListStr, Lists),
            parse_list(ListStr, Numbers),
            check_all_rules(Rules, Numbers)),
           ValidLists),
   findall(Numbers,
           (member(ListStr, Lists),
            parse_list(ListStr, Numbers),
            \+ check_all_rules(Rules, Numbers)),
           InvalidLists).

% Sum middle numbers of list for answer value
get_middle(List, Middle) :-
   length(List, Len),
   Mid is Len // 2,
   nth0(Mid, List, Middle).

sum_middle_numbers([], 0).
sum_middle_numbers([List|Rest], Sum) :-
   get_middle(List, Middle),
   sum_middle_numbers(Rest, RestSum),
   Sum is RestSum + Middle.

% Part two: fix invalid lists
fix_invalid_lists(Rules, InvalidLists, FixedLists) :-
   findall(FixedList,
           (member(List, InvalidLists),
            fix_list(Rules, List, FixedList)),
           FixedLists).

fix_list(Rules, List, FixedList) :-
   find_violation(Rules, List, X, Y),
   !,  % Cut to prevent backtracking if we found a violation
   swap_elements(List, X, Y, NewList),
   fix_list(Rules, NewList, FixedList).
fix_list(_, List, List).  % No violations found, list is fixed

find_violation(Rules, List, X, Y) :-
   member(Rule, Rules),
   parse_rule(Rule, X, Y),
   \+ precedes(X, Y, List).

swap_elements(List, X, Y, NewList) :-
   append(Before, [A|Rest1], List),
   append(Middle, [B|After], Rest1),
   ((A = X, B = Y) ; (A = Y, B = X)),
   !,  % Cut to prevent multiple solutions
   append(Before, [B|Middle], Temp),
   append(Temp, [A|After], NewList).

% main method -- write "main." in the Prolog interpreter to run this
main:-
   open('input.txt', read, Stream),
   read_file(Stream, Lines),
   close(Stream),
   split_on_empty(Lines, Rules, Lists),
   find_valid_lists(Rules, Lists, ValidLists, InvalidLists),
   write('Valid Lists: '), write(ValidLists), nl,
   write('Invalid Lists: '), write(InvalidLists), nl,
   fix_invalid_lists(Rules, InvalidLists, FixedLists),
   write('Fixed Lists: '), write(FixedLists), nl,
   sum_middle_numbers(ValidLists, SumValid),
   write('Sum of middle numbers in valid lists: '), write(SumValid), nl,
   sum_middle_numbers(FixedLists, SumFixed),
   write('Sum of middle numbers in fixed lists: '), write(SumFixed), nl.