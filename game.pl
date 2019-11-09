%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% INCLUDE FILES %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
:- consult('boardDisplay.pl').
:- consult('tests.pl').
:- consult('boards.pl').
:- consult('verifyGameState.pl').
:- consult('filling.pl').
:- consult('adjacents.pl').

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% HELPER FUNCTIONS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

list_empty([]).

switch(X,[Val:Goal | Cases]) :-
  (X=Val -> call(Goal) ; switch(X, Cases)).

getTriangleUp(X,Y,Board,Piece):-
  nth1(Y,Board,Row,_),                                  
  nth1(X,Row,PieceAux,_),
  PieceAux = [Piece|_].   

getTriangleDown(X,Y,Board,Piece):-
  nth1(Y,Board,Row,_),
  nth1(X,Row,PieceAux,_),
  PieceAux = [_|[Piece|_]].

isTri(ID,Tri) :-
  ID == 0, Tri = -1;
  (ID == 1; ID == 2), Tri = -2;
  (ID == 3; ID == 5), Tri = 0;
  (ID == 4; ID == 6), Tri = 1.

getOposPlayer(Player,Opos) :-
  (Player == 1, Opos = 2);
  (Player == 2, Opos = 1).  

%true if variable is not instanced
not_inst(Var):-
  \+(\+(Var=0)),
  \+(\+(Var=1)).

%___________________Auxiliar structure Aux - help functions _______________________%

%add other pieces to auxiliar structure
addAuxOther(X,Y,Board,AuxIn,AuxOut):-
    nth1(Y,Board,Row,_),                           %get row
    nth1(X,Row,Piece,_),                           %get piece
    append([[[Y,X],Piece]], AuxIn, AuxOut).        %add to auxiliar structure

%add triangle up to auxiliar structure
addAuxTriangleUp(X,Y,Board,AuxIn,AuxOut):-
  getTriangleUp(X,Y,Board,Piece),          
  append([[[Y,X],Piece]], AuxIn, AuxOut).

%add triangle down to auxiliar structure
addAuxTriangleDown(X,Y,Board,AuxIn,AuxOut):-
  getTriangleDown(X,Y,Board,Piece),
  append([[[Y,X],Piece]], AuxIn, AuxOut).


%____________________ Possible plays - help functions ________________________________%

%Adds to a list adjacent pieces of the ones already played on board
possiblePlaysAux(_,[],PossiblePlaysOut,PossiblePlaysOut).
possiblePlaysAux(Board,[Piece|Rest],PossiblePlaysIn,PossiblePlaysOut):-
  lookForAdjacent(Board,Piece, Adjacents),
  append(Adjacents,PossiblePlaysIn,T),
  possiblePlaysAux(Board,Rest,T,PossiblePlaysOut).

%remove pieces from possible plays -
%used to remove pieces that were already played
removePiecesOnBoard([],List2,List2).
removePiecesOnBoard([Piece|Rest],List,List2):-
  delete(List,Piece,T),
  removePiecesOnBoard(Rest,T,List2).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% GAME LOGIC %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% State: 0 - continue; 1- Player 1 wins; 2- Player 2 wins; 3- Tie game
resultGame(State):-
  (State == 0,print('nada'));
  \+ (State == 1, winMessage(State));
  \+ (State == 2, winMessage(State));
  \+ (State == 3, tieMessage()).




%validate play
validPlay(Piece,PossiblePlays):-
  list_empty(PossiblePlays);
  member(Piece,PossiblePlays).

%calculate next possible plays based on already played pieces(aux)
possiblePlays(Board,Aux,NoAux):-
  possiblePlaysAux(Board,Aux,[],PossiblePlaysOut),          %adds all adjacent pieces to the ones played on the board
  %remove_dups(PossiblePlaysOut,NoDups),
  removePiecesOnBoard(Aux,PossiblePlaysOut,NoAux),          %removes from list of adjacents the pieces that were already played
  print('Possible Plays: '),print(NoAux),nl.                    % shows to player possible plays

%add piece to auxiliar structure
addPlayAux(AuxIn,Board,X,Y,T, AuxOut):-
    switch(T,[
    -1:addAuxOther(X,Y,Board,AuxIn,AuxOut),
    0:addAuxTriangleUp(X,Y,Board,AuxIn,AuxOut),
    1:addAuxTriangleDown(X,Y,Board,AuxIn,AuxOut)
  ]).

%need to calculate for rectangles too
lookForAdjacent(Board,[Coord|[Info|_]],Adjacents):-
    (Info = [_|[Id|_]],
    Coord = [Y|[X|_]]),
    ((Id == 3, adjacentUp3(Board,X,Y,Adjacents));
    (Id == 4, adjacentDown4(Board,X,Y,Adjacents));
    (Id == 5, adjacentUp5(Board,X,Y,Adjacents));
    (Id == 6, adjacentDown6(Board,X,Y,Adjacents));
    (Id == 0,adjacentSquare(Board,X,Y,Adjacents));
    ((Id == 1; Id == 2),adjacentRectangle(Board,X,Y,Adjacents) )
    ).
  

play(Player, Board, AuxIn, AuxOut,BoardOut,StateOut):-  
    display_game(Board,Player),                     %display board
    possiblePlays(Board,AuxIn,NoAux),
    getPlayInfo(Col,Row,T),
    getShapeAddCoord(Board,Row,Col,T,Piece),
    !,
    validPlay(Piece,NoAux),
    lookForAdjacent(Board,Piece,Adjacents),
    fillPiece(Board,Row,Col,T,Player,BoardOut),        %fill piece with player color
    addPlayAux(AuxIn,BoardOut,Col,Row,T, AuxOut),
    verifyGameState(BoardOut,AuxOut,StateOut),
    resultGame(StateOut).

state(State):- State ==0.

playsLoop(Board,Aux):-
    play(1,Board,Aux,Aux2,BoardOut,StateOut),!,
    state(StateOut),
    play(2,BoardOut,Aux2,AuxF,BoardOut2,StateOut),!,
    state(StateOut),
    playsLoop(BoardOut2,AuxF).                      

gameStart():-
    buildBlankList(L),!, 
    playsLoop(L,[]).                                

