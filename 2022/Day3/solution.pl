:- use_module(library(clpfd)).

file_lines(File, Lines) :-
	setup_call_cleanup(open(File, read, In),
		stream_lines(In, Lines),
		close(In)
	).

stream_lines(Stream, Lines) :-
	read_line_to_string(Stream, Line),
	( Line = end_of_file -> Lines = [];
	  Lines = [Line|Rest], stream_lines(Stream, Rest)
	).

split_at(0, L, [], L).
split_at(N, [ First | Rest ], [ First | TakenRest ], Other) :-
	NPrime #= N - 1,
	split_at(NPrime, Rest, TakenRest, Other).

list_bisect(List, FirstHalf, SecondHalf) :-
	length(List, ListLength),
	ListLength #= HalfLength * 2,
	split_at(HalfLength, List, FirstHalf, SecondHalf).

common_element(ListA, ListB, Elem) :-
	member(Elem, ListA),
	member(Elem, ListB).

item_priority(C, Priority) :-
	C in 97..122,
	Priority #= C - 96.
item_priority(C, Priority) :-
	C in 65..90,
	Priority #= C - 64 + 26.

groups_of_n(_, [], []).
groups_of_n(N, List, [ Group | RestGrouped ]) :-
	split_at(N, List, Group, Rest),
	groups_of_n(N, Rest, RestGrouped).

first_solution(FileName, Solution) :-
	file_lines(FileName, Lines),
	maplist(string_codes, Lines, LineCodes),
	maplist(list_bisect, LineCodes, FirstHalves, SecondHalves),
	maplist(common_element, FirstHalves, SecondHalves, MisplacedItems),
	maplist(item_priority, MisplacedItems, Priorities),
	foldl(plus, Priorities, 0, Solution).

common_element(Groups, Elem) :- maplist(member(Elem), Groups).

second_solution(FileName, Solution) :-
	file_lines(FileName, Lines),
	maplist(string_codes, Lines, LineCodes),
	groups_of_n(3, LineCodes, Groups),
	maplist(common_element, Groups, Elements),
	maplist(item_priority, Elements, Priorities),
	foldl(plus, Priorities, 0, Solution).
