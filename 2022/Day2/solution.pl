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

rps_outcome(rock, scissors, win).
rps_outcome(paper, rock, win).
rps_outcome(scissors, paper, win).
rps_outcome(X, X, tie).
rps_outcome(X, Y, lose) :- rps_outcome(Y, X, win).

outcome_score(win, 6).
outcome_score(lose, 0).
outcome_score(tie, 3).

move_score(rock, 1).
move_score(paper, 2).
move_score(scissors, 3).

rps_score(You, Opponent, Score) :-
	rps_outcome(You, Opponent, Outcome),
	outcome_score(Outcome, OutcomeScore),
	move_score(You, MoveScore),
	Score #= OutcomeScore + MoveScore.

first_parse([OpponentCode, _, YouCode], Opponent, You) :-
	parse_opponent_code(OpponentCode, Opponent),
	parse_first_you_code(YouCode, You).

second_parse([OpponentCode, _, YouCode], Opponent, You) :-
	parse_opponent_code(OpponentCode, Opponent),
	parse_second_you_code(YouCode, You).

parse_opponent_code(65, rock).
parse_opponent_code(66, paper).
parse_opponent_code(67, scissors).

parse_first_you_code(88, rock).
parse_first_you_code(89, paper).
parse_first_you_code(90, scissors).

parse_second_you_code(88, lose).
parse_second_you_code(89, tie).
parse_second_you_code(90, win).

sum([], 0).
sum([ First | Rest ], Sum) :-
	Sum #= First + SumRest,
	sum(Rest, SumRest).

first_solution(InputFile, Solution) :-
	file_lines(InputFile, Lines),
	maplist(string_codes, Lines, LineCodes),
	maplist(first_parse, LineCodes, OpponentMoves, MyMoves),
	maplist(rps_score, MyMoves, OpponentMoves, Scores),
	sum(Scores, Solution).

second_solution(InputFile, Solution) :-
	file_lines(InputFile, Lines),
	maplist(string_codes, Lines, LineCodes),
	maplist(second_parse, LineCodes, OpponentMoves, MyOutcomes),
	maplist(rps_outcome, MyMoves, OpponentMoves, MyOutcomes),
	maplist(rps_score, MyMoves, OpponentMoves, Scores),
	sum(Scores, Solution).
