:- use_module(library(clpfd)).
:- use_module(library(lists)).
:- use_module(library(random)).
% 0 - blank 1 - C (Close) 2 - F (Far)

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
  
displayBoard([]) :- !,nl.
displayBoard([R|Rs]) :-
  write(R),nl,
  displayBoard(Rs).

test :-
  Test = [
    [_A1,_A2,_A3,1],
    [_B1,1,_B3,_B4],
    [1,_C2,_C3,_C4],
    [_D1,_D2,1,_D4]
  ],
  solver(Test),
  displayBoard(Test).

%%%%%%%%%%%%%%%%%%% BOARD GENERATION %%%%%%%%%%%%%%%%%%%%

generate(N,NewB):-
  solver(B,N,[variable(selRandom),value(selRandom)]),
  createPuzzle(B,NewB).

createPuzzle(B,NewB).% create

selRandom(ListOfVars, Var, Rest) :-
  random_select(Var, ListOfVars, Rest).

selRandom(Var, Rest, BB0, BB1):- % selecionavalor de forma aleatória
  fd_set(Var, Set), fdset_to_list(Set, List), random_member(Value,List), % da library(random)
  (first_bound(BB0, BB1), Var#= Value;
  later_bound(BB0, BB1), Var#\= Value).

%%%%%%%%%%%%%%%%%%%%%%%%% GENERATE AND SOLVE %%%%%%%%%%%%%

close_or_far(N) :-
  generate(N,B),
  displayBoard(B),nl,nl,!,
  solver(B,N,[ffc]),
  displayBoard(B).

  
  
  
  

  