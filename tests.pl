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
verifyPlayerTest(PState) :-
  buildFinalList(L),
  display_game(L,2),
  InPlay = [[[3,6],[2,4]],
            [[4,5],[2,6]],[[4,5],[1,5]],[[4,6],[1,0]],[[4,7],[1,6]],[[4,8],[1,0]],
            [[5,5],[2,0]],[[5,6],[1,3]],[[5,6],[2,4]],[[5,7],[2,0]],[[5,8],[1,4]],
            [[6,5],[2,5]],[[6,6],[1,0]],[[6,7],[1,5]],[[6,7],[2,6]],[[6,8],[1,0]],
            [[7,8],[2,3]]],
  verifyPlayerState(L,2,InPlay,PState).

%Both P1State and P2State must return 1, both losing (tie)
verifyTieTest2(P1State,P2State) :-
  buildTieList(L),
  display_game(L,2),
  InPlay = [[[4,5],[1,6]],[[4,5],[1,5]],[[4,6],[2,0]],[[4,7],[2,6]],[[4,7],[2,5]],
            [[5,4],[1,4]],[[5,5],[2,0]],[[5,6],[1,3]],[[5,6],[2,4]],[[5,7],[2,0]],
            [[6,4],[1,0]],[[6,5],[1,6]],[[6,5],[1,5]],[[6,6],[2,0]],[[6,7],[2,5]],[[6,7],[2,6]],
            [[7,6],[1,3]]],
  verifyPlayerState(L,2,InPlay,P2State),verifyPlayerState(L,1,InPlay,P1State).

%State expected is 3 - Tie game
verifyGameTestTie(StateOut) :-
  buildTieList(L),
  display_game(L,2),
  InPlay = [[[4,5],[1,6]],[[4,5],[1,5]],[[4,6],[2,0]],[[4,7],[2,6]],[[4,7],[2,5]],
          [[5,4],[1,4]],[[5,5],[2,0]],[[5,6],[1,3]],[[5,6],[2,4]],[[5,7],[2,0]],
          [[6,4],[1,0]],[[6,5],[1,6]],[[6,5],[1,5]],[[6,6],[2,0]],[[6,7],[2,5]],[[6,7],[2,6]],
          [[7,6],[1,3]]],
  verifyGameState(L,InPlay,StateOut).

%State expected is 1 - Player 1 wins
verifyGameTestEnd(StateOut) :-
  buildFinalList(L),
  display_game(L,2),
  InPlay = [[[3,6],[2,4]],
            [[4,5],[2,6]],[[4,5],[1,5]],[[4,6],[1,0]],[[4,7],[1,6]],[[4,8],[1,0]],
            [[5,5],[2,0]],[[5,6],[1,3]],[[5,6],[2,4]],[[5,7],[2,0]],[[5,8],[1,4]],
            [[6,5],[2,5]],[[6,6],[1,0]],[[6,7],[1,5]],[[6,7],[2,6]],[[6,8],[1,0]],
            [[7,8],[2,3]]],
  verifyGameState(L,InPlay,StateOut). 

getRandomPieceTest(Row,Col,Tri) :-
  PieceList = [[[1,2],[0,4]],[[4,2],[2,2]],[[7,8],[1,6]],[[5,1],[2,1]],[[6,8],[1,3]],[[5,4],[0,2]]],
  getRandomPiece(PieceList,Row,Col,Tri).

evalPieceTest(N) :- %expected N is -6/-7
  buildFinalList(L),
  Player is 2,
  InPlay = [[[3,6],[2,4]],
            [[4,5],[2,6]],[[4,5],[1,5]],[[4,6],[1,0]],[[4,7],[1,6]],[[4,8],[1,0]],
            [[5,5],[2,0]],[[5,6],[1,3]],[[5,6],[2,4]],[[5,7],[2,0]],[[5,8],[1,4]],[[5,8],[2,3]],
            [[6,5],[2,5]],[[6,6],[1,0]],[[6,7],[1,5]],[[6,7],[2,6]],[[6,8],[1,0]],
            [[7,8],[2,3]]],
  PossPiece = [[3,5],[0,0]],
  evalPiece(L,InPlay,Player,PossPiece,N).

  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 