:- consult('game.pl').

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TESTING %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

fillPieceTest() :-
    buildBlankList(L),
    display_game(L,1),
    fillPiece(L,1,10,-2,1,L2),
    printBoardByRow(L2),
    display_game(L2,2).

printBoardByRow([]) :- !.
printBoardByRow([Row|Rest]):-
  print(Row),nl,
  printBoardByRow(Rest).

lookAdjsTest(Adjs,Row,Col,ID) :-
  buildIntList(L),
  display_game(L,1),
  lookForAdjacent(L,[[Row,Col],[_,ID]],Adjs).

processAdjsTest(InPlay2,PieceState) :-
  buildFinalList(L),
  display_game(L,1),
  AdjsTo = [[[5,7],[2,0]]],
  InPlay = [[[3,6],[2,4]],
            [[4,5],[2,6]],[[4,5],[1,5]],[[4,6],[1,0]],[[4,7],[1,6]],[[4,8],[1,0]],
            [[5,5],[2,0]],[[5,6],[1,3]],[[5,6],[2,4]],[[5,7],[2,0]],[[5,8],[1,4]],
            [[6,5],[2,5]],[[6,6],[1,0]],[[6,7],[1,5]],[[6,7],[2,6]],[[6,8],[1,0]],
            [[7,8],[2,3]]],
  processAdjs(L,2,AdjsTo, InPlay,InPlay2,TabOut,PieceState),
  display_game(TabOut,1).

%PState is expected to return 1, losing
verifyPlayerTest() :-
  buildFinalList(L),
  display_game(L,2),
  InPlay = [[[3,6],[2,4]],
            [[4,5],[2,6]],[[4,5],[1,5]],[[4,6],[1,0]],[[4,7],[1,6]],[[4,8],[1,0]],
            [[5,5],[2,0]],[[5,6],[1,3]],[[5,6],[2,4]],[[5,7],[2,0]],[[5,8],[1,4]],
            [[6,5],[2,5]],[[6,6],[1,0]],[[6,7],[1,5]],[[6,7],[2,6]],[[6,8],[1,0]],
            [[7,8],[2,3]]],
  verifyPlayerState(L,2,InPlay,PState),
  PState == 1.

%Both P1State and P2State must return 1, both losing (tie)
verifyTieTest2() :-
  buildTieList(L),
  display_game(L,2),
  InPlay = [[[4,5],[1,6]],[[4,5],[1,5]],[[4,6],[2,0]],[[4,7],[2,6]],[[4,7],[2,5]],
            [[5,4],[1,4]],[[5,5],[2,0]],[[5,6],[1,3]],[[5,6],[2,4]],[[5,7],[2,0]],
            [[6,4],[1,0]],[[6,5],[1,6]],[[6,5],[1,5]],[[6,6],[2,0]],[[6,7],[2,5]],[[6,7],[2,6]],
            [[7,6],[1,3]]],
  verifyPlayerState(L,2,InPlay,P2State),verifyPlayerState(L,1,InPlay,P1State),
  P1State == 1, P2State == 1.

%State expected is 3 - Tie game
verifyGameTestTie() :-
  buildTieList(L),
  display_game(L,2),
  InPlay = [[[4,5],[1,6]],[[4,5],[1,5]],[[4,6],[2,0]],[[4,7],[2,6]],[[4,7],[2,5]],
          [[5,4],[1,4]],[[5,5],[2,0]],[[5,6],[1,3]],[[5,6],[2,4]],[[5,7],[2,0]],
          [[6,4],[1,0]],[[6,5],[1,6]],[[6,5],[1,5]],[[6,6],[2,0]],[[6,7],[2,5]],[[6,7],[2,6]],
          [[7,6],[1,3]]],
  value(L,InPlay,StateOut),
  StateOut == 3.

%State expected is 1 - Player 1 wins
verifyGameTestEnd() :-
  buildFinalList(L),
  display_game(L,2),
  InPlay = [[[3,6],[2,4]],
            [[4,5],[2,6]],[[4,5],[1,5]],[[4,6],[1,0]],[[4,7],[1,6]],[[4,8],[1,0]],
            [[5,5],[2,0]],[[5,6],[1,3]],[[5,6],[2,4]],[[5,7],[2,0]],[[5,8],[1,4]],
            [[6,5],[2,5]],[[6,6],[1,0]],[[6,7],[1,5]],[[6,7],[2,6]],[[6,8],[1,0]],
            [[7,8],[2,3]]],
  verifyGameState(L,InPlay,StateOut),
  StateOut == 1. 

getRandomPieceTest(Row,Col,Tri) :-
  PieceList = [[[1,2],[0,4]],[[4,2],[2,2]],[[7,8],[1,6]],[[5,1],[2,1]],[[6,8],[1,3]],[[5,4],[0,2]]],
  getRandomPiece(PieceList,Row,Col,Tri).

evalPieceTest(N) :- %expected N is -7
  buildGreedyList(L),
  Player is 2,
  display_game(L,Player),
  InPlay = [[[3,5],[2,0]],[[3,6],[2,4]],
          [[4,5],[1,6]],[[4,5],[2,5]],[[4,6],[1,0]],[[4,7],[2,5]],[[4,7],[1,6]],[[4,8],[2,0]],
          [[5,4],[2,3]],[[5,4],[1,4]],[[5,6],[1,3]],[[5,6],[1,4]],[[5,8],[2,4]],
          [[6,5],[1,5]],[[6,6],[1,0]],[[6,7],[1,5]],[[6,7],[1,6]],[[6,8],[2,0]],
          [[7,6],[2,3]],[[7,7],[2,0]]],
  PossPiece = [[6,5],[0,6]],
  evalPiece(L,InPlay,Player,PossPiece,N).

%In this particular case the greedy strategy makes the player 2, that was in better position
%to win the game, entrap himself and lose the game
getGreedyTest(Row,Col,Tri) :-
  buildGreedyList(L),
  Player is 2,
  display_game(L,Player),
  InPlay = [[[3,5],[2,0]],[[3,6],[2,4]],
            [[4,5],[1,6]],[[4,5],[2,5]],[[4,6],[1,0]],[[4,7],[2,5]],[[4,7],[1,6]],[[4,8],[2,0]],
            [[5,4],[2,3]],[[5,4],[1,4]],[[5,6],[1,3]],[[5,6],[1,4]],[[5,6],[1,3]],[[5,8],[2,4]],
            [[6,5],[2,5]],[[6,6],[1,0]],[[6,7],[1,5]],[[6,7],[1,6]],[[6,8],[2,0]],
            [[7,6],[2,3]],[[7,7],[2,0]]],
  valid_moves(L,InPlay,PossList),
  getGreedyPiece(L,InPlay,Player,PossList,Row,Col,Tri).

display_greedy() :-
  buildGreedyList(L),
  display_game(L,2).
  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 