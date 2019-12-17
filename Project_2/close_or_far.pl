:- use_module(library(clpfd)).
:- use_module(library(lists)).
:- use_module(library(random)).
% 0 - blank 1 - C (Close) 2 - F (Far)

solver(Board) :-
  length(Board,N),
  NZeros is N-4,
  constraintRows(Board,N,NZeros),
  transpose(Board, BoardT),
  constraintRows(BoardT,N,NZeros),
  append(Board, Brd),
  labeling([ffc], Brd).

constraintRows([],0,_).
constraintRows([R|Rs],N,NZeros) :-
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
  N1 is N-1,
  constraintRows(Rs,N1,NZeros).
  
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

generate(N) :-
  generateBoard(N,B),
  displayBoard(B).

generateBoard(Rows,Board) :-
  length(Board,Rows),
  boardInit(Board,Rows),
  generateCols(Rows,Cols),
  assignVars(Cols,Rows,Board).

boardInit([],_).
boardInit([Row|Rs],N) :-
  length(Row,N),
  boardInit(Rs,N).

generateCols(N,Cols) :-
  length(Cols,N),
  domain(Cols,1,N),
  all_distinct(Cols),
  labeling([variable(selRandom)],Cols).

selRandom(ListOfVars, Var, Rest) :-
  random_select(Var, ListOfVars, Rest).

assignVars([],0,_).
assignVars([C|Cs],R,Board) :-
  random(1,2,E),
  nth1(R,Board,Row),
  nth1(C,Row,E),
  R1 is R-1,
  assignVars(Cs,R1,Board).
  
%%%%%%%%%%%%%%%%%%%%%%%%% GENERATE AND SOLVE %%%%%%%%%%%%%

close_or_far(N) :-
  generateBoard(N,B),
  displayBoard(B),nl,nl,!,
  solver(B),
  displayBoard(B).



  
  
  
  

  