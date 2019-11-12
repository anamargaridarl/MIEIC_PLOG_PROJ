%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% INCLUDE FILES %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
:- consult('boardDisplay.pl').
:- consult('boards.pl').
:- consult('verifyGameState.pl').
:- consult('filling.pl').
:- consult('adjacents.pl').
:- consult('computer.pl').
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

isT(Id):- (Id == 3;Id ==4; Id ==5; Id ==6).

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

  % %get piece full info
getFullPiece(Col,Row,Board,[[_,_],Info]) :-
  getPiece(Col,Row,Board,Info).

%get piece from board based on X and Y position
getPiece(Col,Row,Board,Piece):-
  nth1(Row,Board,RowAux,_),
  nth1(Col,RowAux,Piece,_).

getShapeRecSq(Row,Col,Board,PieceAux,T):-
      getPiece(Col,Row,Board,PieceAux),
      PieceAux = [_|[Id|_]],
      isTri(Id,T).

%get shape 
getShapeAddCoord(Board,Row,Col,Tri,Tout,Piece) :-
  switch(Tri,[
    -1:getShapeRecSq(Row,Col,Board,PieceAux,Tout),
    0: (getTriangleUp(Col,Row,Board,PieceAux), Tout is Tri),
    1: (getTriangleDown(Col,Row,Board,PieceAux),  Tout is Tri)
  ]),
  append([[Row,Col]],[PieceAux],Piece).


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
validMovesAux(_,[],PossiblePlaysOut,PossiblePlaysOut).
validMovesAux(Board,[Piece|Rest],PossiblePlaysIn,PossiblePlaysOut):-
  lookForAdjacent(Board,Piece, Adjacents),
  append(Adjacents,PossiblePlaysIn,T),
  validMovesAux(Board,Rest,T,PossiblePlaysOut).

%remove pieces from possible plays -
%used to remove pieces that were already played
removePiecesOnBoard([],List2,List2).
removePiecesOnBoard([Piece|Rest],List,List2):-
  delete(List,Piece,T),
  removePiecesOnBoard(Rest,T,List2).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% GAME LOGIC %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% State: 0 - continue; 1- Player 1 wins; 2- Player 2 wins; 3- Tie game
game_over(State):-
  (State == 0);
  (State == 1, winMessage(State),fail);
  (State == 2, winMessage(State),fail);
  (State == 3, tieMessage(),fail).

%validate play
validPlay(Piece,PossiblePlays):-
  (list_empty(PossiblePlays),
   Piece = [_|[Info|_]],
   Info = [_ |[Id |_]],
   isT(Id));
  member(Piece,PossiblePlays).

%calculate next possible plays based on already played pieces(aux)
valid_moves(Board,Aux,NoAux):-
  validMovesAux(Board,Aux,[],PossiblePlaysOut),          %adds all adjacent pieces to the ones played on the board
  %remove_dups(PossiblePlaysOut,NoDups),
  removePiecesOnBoard(Aux,PossiblePlaysOut,NoAux).          %removes from list of adjacents the pieces that were already played
  %print('Possible Plays: '),print(NoAux),nl.                    % shows to player possible plays

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
  
move(Player, Board, AuxIn, AuxOut,BoardOut,StateOut):-
    display_game(Board,Player),!,                   %display board
    valid_moves(Board,AuxIn,NoAux),repeat,
    getPlayInfo(Col,Row,T), 
    getShapeAddCoord(Board,Row,Col,T,Tout,Piece),
    validPlay(Piece,NoAux),
    fillPiece(Board,Row,Col,Tout,Player,BoardOut),        %fill piece with player color
    addPlayAux(AuxIn,BoardOut,Col,Row,T, AuxOut),
    value(BoardOut,AuxOut,StateOut).

playsLoop(Board,Aux):-
    move(1,Board,Aux,Aux2,BoardOut,StateOut),!,
    game_over(StateOut),
    move(2,BoardOut,Aux2,AuxF,BoardOut2,StateOut2),!,
    game_over(StateOut2),!,
    playsLoop(BoardOut2,AuxF).                      

play():-
    buildBlankList(L),!,
    playsLoop(L,[]).                                