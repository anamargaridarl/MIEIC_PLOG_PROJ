:- use_module(library(clpfd)).
:- use_module(library(lists)).
:- use_module(library(random)).
% 0 - blank 1 - C (Close) 2 - F (Far)
%%%%%%%%%%%%%%%%%%%%%%%% PUZZLE SOLVER %%%%%%%%%%%%%%%%%%%%%%%%%%%
solver(Board,N,Opt) :-
  length(Board,N),
  NZeros is N-4,
  constraintRows(Board,N,NZeros),
  transpose(Board, BoardT),
  constraintRows(BoardT,N,NZeros),
  append(Board, Brd),
  labeling(Opt, Brd).

constraintRows([],_,_).
constraintRows([R|Rs],N,NZeros) :-
  length(R,N),
  domain(R,0,2),
  global_cardinality(R, [1-2, 2-2,0-NZeros]),
  element(I1, R, 1),
  element(I2, R, 1),
  element(I3, R, 2),
  element(I4, R, 2),
  I1 #< I2, I3 #< I4,
  DC #= abs(I2 - I1),
  DF #= abs(I4 - I3),
  DC #< DF,
  constraintRows(Rs,N,NZeros).

%%%%%%%%%%%%%%%%%%% BOARD GENERATION %%%%%%%%%%%%%%%%%%%%

generate(N,NewB):-
  solver(B,N,[variable(selRandom),value(selRandom)]),
  createPuzzle(B,N,NewB),displayBoard(B).

createPuzzle(B,N,NewB) :-
  selectPieces(B,N,Pos,Types),
  length(NewB,N),
  buildBoard(NewB,N,Pos,Types).

selectPieces(B,N,Pos,Types) :-
  length(Pos,N),
  length(Types,N),
  domain(Pos,1,N),
  domain(Types,1,2),
  all_distinct(Pos),
  constrainPiece(B,Pos,Types),
  append(Pos,Types,Vars),
  labeling([value(selRandom)],Vars).

constrainPiece([],[],[]).
constrainPiece([Row|Bs],[P|Ps],[1|Ts]) :-
  element(P,Row,1),
  constrainPiece(Bs,Ps,Ts).

constrainPiece([Row|Bs],[P|Ps],[2|Ts]) :-
  element(P,Row,2),
  constrainPiece(Bs,Ps,Ts).  

buildBoard([],_,[],[]).
buildBoard([Row|Bs],N,[P|Ps],[T|Ts]) :-
  length(Row,N),
  nth1(P,Row,T),
  buildBoard(Bs,N,Ps,Ts).

%%%%%%%%%%%%%%%%%%%%%%%%% GENERATE AND SOLVE %%%%%%%%%%%%%

close_or_far(N) :-
  reset_timer,
  generate(N,B),
  print_time,
  fd_statistics,
  displayBoard(B),nl,nl,!,
  reset_timer,
  solver(B,N,[ffc]),
  print_time,
	fd_statistics,
  displayBoard(B).


%%%%%%%%%%%%%%%%%%%%%%%%%% STATISTICS %%%%%%%%%%%%%%%%%%%%%

reset_timer :- statistics(walltime,_).	
print_time :-
	statistics(walltime,[_,T]),
	TS is ((T//10)*10)/1000,
	nl, write('Time: '), write(TS), write('s'), nl, nl.


%%%%%%%%%%%%%%%%%%%%%%%%%% LABELING HEURISTICS %%%%%%%%%%%%%%%%%
  
selRandom(ListOfVars, Var, Rest) :-
  random_select(Var, ListOfVars, Rest).

selRandom(Var,_, BB0, BB1):- % selecionavalor de forma aleatória
  fd_set(Var, Set), fdset_to_list(Set, List), random_member(Value,List), % da library(random)
  (first_bound(BB0, BB1), Var#= Value;
  later_bound(BB0, BB1), Var#\= Value).
  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TESTING %%%%%%%%%%%%%%%%%%%%%%%%%

test :-
  Test = [
    [_A1,_A2,_A3,1],
    [_B1,1,_B3,_B4],
    [1,_C2,_C3,_C4],
    [_D1,_D2,1,_D4]
  ],
  solver(Test),
  displayBoard(Test).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% BOARD DISPLAY %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

displayBoard([]) :- !,nl.
displayBoard([R|Rs]) :-
  write('|'),
  displayRow(R),
  displayBoard(Rs).

displayRow([]) :- nl.
displayRow([R|Rs]) :-
  var(R),
  write(' |'),
  displayRow(Rs).

displayRow([0|Rs]) :-
  write(' |'),
  displayRow(Rs).

displayRow([1|Rs]) :-
  write('C|'),
  displayRow(Rs).

displayRow([2|Rs]) :-
  write('F|'),
  displayRow(Rs).