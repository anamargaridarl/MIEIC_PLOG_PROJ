:- use_module(library(clpfd)).
:- use_module(library(lists)).
:- use_module(library(random)).
% 0 - blank 1 - C (Close) 2 - F (Far)
%%%%%%%%%%%%%%%%%%%%%%%% PUZZLE SOLVER %%%%%%%%%%%%%%%%%%%%%%%%%%%
solver(Board,N,Opt) :-
  length(Board,N),
  NZeros is N-4,
  constraintRows(Board,N,NZeros), % aplicar as restrições das linhas
  transpose(Board, BoardT),       % transpor a matriz do tabuleiro
  constraintRows(BoardT,N,NZeros), % aplicar as restrições das colunas
  append(Board, Brd),
  labeling(Opt, Brd).

constraintRows([],_,_).
constraintRows([R|Rs],N,NZeros) :-
  length(R,N),
  automaton(R,_,R,
    [source(s),sink(h)],
    [arc(s,0,s),arc(s,1,a),arc(s,2,b),
     arc(a,0,a,[C+1,F]),arc(a,1,c),arc(a,2,d,[C+1,F]),
     arc(b,0,b,[C,F+1]),arc(b,1,d,[C,F+1]),arc(b,2,e),
     arc(c,0,c),arc(c,2,f),
     arc(d,0,d,[C+1,F+1]),arc(d,1,f,[C,F+1]),arc(d,2,g,[C+1,F]),
     arc(e,0,e),arc(e,1,g),
     arc(f,0,f,[C,F+1]),arc(f,2,h),
     arc(g,0,g,[C+1,F]),arc(g,1,h),
     arc(h,0,h)],
    [C,F],[0,0],[A,B]),
  A#<B,
  constraintRows(Rs,N,NZeros).

%%%%%%%%%%%%%%%%%%% BOARD GENERATION %%%%%%%%%%%%%%%%%%%%

generate(N,NewB):-
  solver(B,N,[variable(selRandom),value(selRandom)]), % gerar um tabuleiro resolvido
  createPuzzle(B,N,NewB).

createPuzzle(B,N,NewB) :-
  selectPieces(B,N,Pos,Types), %Pos é uma lista que guarda a coluna de cada linha onde estará uma letra e Types é a lista de letras por linha
  length(NewB,N),
  buildBoard(NewB,N,Pos,Types).

selectPieces(B,N,Pos,Types) :-
  length(Pos,N),
  length(Types,N),
  domain(Pos,1,N),
  domain(Types,1,2),
  all_distinct(Pos),
  constrainPiece(B,Pos,Types), % preencher as listas Pos e Types
  append(Pos,Types,Vars),
  labeling([value(selRandom)],Vars).

constrainPiece([],[],[]).
constrainPiece([Row|Bs],[P|Ps],[T|Ts]) :-
  T in 1..2,
  element(P,Row,T),
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
    [_,_,1,_,_,_,_],
    [2,_,_,_,_,_,_],
    [_,_,_,_,_,_,1],
    [_,_,_,1,_,_,_],
    [_,_,_,_,2,_,_],
    [_,1,_,_,_,_,_],
    [_,_,_,_,_,2,_]
  ],
  solver(Test,7,[ffc]),
  displayBoard(Test).

test_automata(Seq) :-
  domain([M,N],0,20),
  automaton(Seq,_,Seq,
    [source(s),sink(h)],
    [arc(s,0,s),arc(s,1,a),arc(s,2,b),
     arc(a,0,a,[C+1,F]),arc(a,1,c),arc(a,2,d,[C+1,F]),
     arc(b,0,b,[C,F+1]),arc(b,1,d,[C,F+1]),arc(b,2,e),
     arc(c,0,c),arc(c,2,f),
     arc(d,0,d,[C+1,F+1]),arc(d,1,f,[C,F+1]),arc(d,2,g,[C+1,F]),
     arc(e,0,e),arc(e,1,g),
     arc(f,0,f,[C,F+1]),arc(f,2,h),
     arc(g,0,g,[C+1,F]),arc(g,1,h),
     arc(h,0,h)],
    [C,F],[0,0],[M,N]),
    M#<N,
    labeling([],[M,N]).

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