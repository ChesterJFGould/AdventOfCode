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

split([], _, []).
split(List, Sep, [ Chunk | Rest ]) :-
	until(List, Sep, Chunk, AfterSep),
	split(AfterSep, Sep, Rest).

until([], _, [], []).
until([Sep | AfterSep], Sep, [], AfterSep).
until([First | Rest], Sep, [First | Chunk], AfterSep) :-
	dif(First, Sep),
	until(Rest, Sep, Chunk, AfterSep).

sum([], 0).
sum([ First | Rest ], Sum) :-
	Sum #= First + SumRest,
	sum(Rest, SumRest).

sum_subs(Subs, Sums) :- maplist(sum, Subs, Sums).

subs_as_nums(Subs, NumSubs) :- maplist(maplist(number_string), NumSubs, Subs).

max_in_list(Max, [ First | Rest ]) :-
	max_in_list(RestMax, Rest) -> Max #= max(RestMax, First);
	Max = First.

first_solution(Solution, InputFile) :-
	file_lines(InputFile, Lines),
	split(Lines, "", SplitLines),
	subs_as_nums(SplitLines, Calories),
	sum_subs(Calories, CalorieSums),
	max_in_list(Solution, CalorieSums).

second_solution(Solution, InputFile) :-
	file_lines(InputFile, Lines),
	split(Lines, "", SplitLines),
	subs_as_nums(SplitLines, Calories),
	sum_subs(Calories, CalorieSums),
	sort(CalorieSums, SortedCalorieSums),
	reverse(SortedCalorieSums, [A, B, C | _]),
	Solution #= A + B + C.
