%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% INCLUDE FILES %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
:- consult('boardDisplay.pl').

   remove_dups(L, U) :-
       remove_dups(L, [], U, []).
   
   remove_dups([E|L], H0, R0, T) :-
       ( \+ memberchk(E, H0) ->
         R0 = [E|R],
         H = [E|H0 ]
       ; R = R0,
         H = H0
       ),
       remove_dups(L, H, R, T).
   remove_dups([], _, T, T).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% HELPER FUNCTIONS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
switch(X,[Val:Goal | Cases]) :-
  (X=Val -> call(Goal) ; switch(X, Cases)).

getPieceFillOther(TabIn,Row,Col,FillOut):-
  nth1(Row,TabIn,Line,_),
  nth1(Col,Line,[FillOut|_],_).

getPieceFillTriUp(TabIn,Row,Col,FillOut) :-
  nth1(Row,TabIn,Line,_),
  nth1(Col,Line,[[FillOut,_|_]|_],_).

getPieceFillTriDwn(TabIn,Row,Col,FillOut) :-
  nth1(Row,TabIn,Line,_),
  nth1(Col,Line,[_,[FillOut,_|_]|_],_).

getPieceFill(TabIn,Row,Col,Tri,FillOut) :-
  switch(Tri,[
    -1:getPieceFillOther(TabIn,Row,Col,FillOut),
    0:getPieceFillTriUp(TabIn,Row,Col,FillOut),
    1:getPieceFillTriDwn(TabIn,Row,Col,FillOut)
  ]).

%without triangles
% validPlay(Aux,X,Y,T) :- 
%   Xless is X -1,
%   Xmore is X +1,
%   Yless is Y-1,
%   Ymore is Y+1,
%   member([Xless,Y], Aux);
%   member([Xmore,Y], Aux);
%   member([X,Ymore], Aux);
%   member([X,Yless], Aux).

getTriangleUp(X,Y,Board,Piece):-
  nth1(Y,Board,Row,_),                                  
  nth1(X,Row,PieceAux,_),
  PieceAux = [Piece|_].   

getTriangleDown(X,Y,Board,Piece):-
  nth1(Y,Board,Row,_),
  nth1(X,Row,PieceAux,_),
  PieceAux = [_|[Piece|_]].

isTri(ID,Tri) :-
  (ID == 0; ID == 1; ID == 2), Tri = -1;
  (ID == 3; ID == 5), Tri = 0;
  (ID == 4; ID == 6), Tri = 1.

getOposPlayer(Player,Opos) :-
  (Player == 1, Opos = 2);
  (Player == 2, Opos = 1).  

%___________________Auxiliar structure helper functions _______________________%

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

%____________________ Adjacent Pieces _____________________________________________%
%get piece from board based on X and Y position
getPiece(X,Y,Board,Piece):-
  nth1(Y,Board,Row,_),
  nth1(X,Row,Piece,_).

%get shape 
getShapeAddCoord(Board,Row,Col,Tri,Piece) :-
  switch(Tri,[
    -1:getPiece(Row,Col,Board,PieceAux),
    0:getTriangleUp(Row,Col,Board,PieceAux),
    1:getTriangleDown(Row,Col,Board,PieceAux)
  ]),
  append([[Row,Col]],[PieceAux],Piece).

%adjacents to triangle5
adjacentUp5(Board,X,Y,Adjacents):-
  Xmore is X +1,
  Yless is Y-1,
  getPiece(Xmore,Y,Board,Piece1),
  getTriangleDown(X,Y,Board,Piece2),
  getPiece(X,Yless,Board,Piece3),
  append([  [[Y,Xmore],Piece1],  [[Y,X],Piece2], [ [Yless,X], Piece3]],[],Adjacents).

%adjacents to triangle3
adjacentUp3(Board,X,Y,Adjacents):-
  Xless is X -1,
  Yless is Y -1,
  getPiece(Xless,Y,Board,Piece1),  
  getTriangleDown(X,Y,Board,Piece2),
  getPiece(X,Yless,Board,Piece3),
  append([  [[Y,Xless],Piece1],  [[Y,X],Piece2], [ [Yless,X], Piece3]],[],Adjacents).

%adjacents to triangle4
adjacentDown4(Board,X,Y,Adjacents):-
  Xmore is X +1,
  Ymore is Y+1,
  getPiece(Xmore,Y,Board,Piece1),
  getTriangleUp(X,Y,Board,Piece2),
  getPiece(X,Ymore,Board,Piece3),
  append([  [[Y,Xmore],Piece1],  [[Y,X],Piece2], [ [Ymore,X], Piece3]],[],Adjacents).

%adjacent to triangle6
adjacentDown6(Board,X,Y,Adjacents):-
  Xless is X -1,
  Yless is Y-1,
  getPiece(Xless,Y,Board,Piece1),
  getTriangleUp(X,Y,Board,Piece2),
  getPiece(X,Yless,Board,Piece3),
  append([  [[Y,Xless],Piece1],  [[Y,X],Piece2], [ [Yless,X], Piece3]],[],Adjacents).

%adjacents of squares in case of left top unit in board (not counting rectangles)
adjacentSquareLeftTop(X,Y,Board,Adjacents,Xmore,Xless,Ymore,Yless):-
  getTriangleDown(Xmore,Y,Board,Piece1),
  getPiece(Xless,Y,Board,Piece2),
  getTriangleUp(X,Ymore,Board,Piece4),
  getPiece(X,Yless,Board,Piece3),
  append([  [[Y,Xmore],Piece1],  [[Y,Xless],Piece2], [ [Ymore,X], Piece3], [[Yless,X],Piece4]],[],Adjacents).

%adjacents of squares in case of left column in board (not counting rectangles)
adjacentSquareLeft(X,Y,Board,Adjacents,Xmore,Xless,Ymore,Yless):-
  getTriangleDown(Xmore,Y,Board,Piece1),
  getPiece(Xless,Y,Board,Piece2),
  getTriangleDown(X,Ymore,Board,Piece3),
  getTriangleUp(X,Yless,Board,Piece4),
  append([  [[Y,Xmore],Piece1],  [[Y,Xless],Piece2], [ [Ymore,X], Piece3], [[Yless,X],Piece4]],[],Adjacents).

%adjacents of squares in case of top line in board (not counting rectangles)
adjacentSquareTop(X,Y,Board,Adjacents,Xmore,Xless,Ymore,Yless):-
  getTriangleDown(Xmore,Y,Board,Piece1),
  getTriangleUp(Xless,Y,Board,Piece2),
  getTriangleUp(X,Ymore,Board,Piece4),
  getPiece(X,Yless,Board,Piece3),
  append([  [[Y,Xmore],Piece1],  [[Y,Xless],Piece2], [ [Ymore,X], Piece3], [[Yless,X],Piece4]],[],Adjacents).

%adjacents of squares in case of right bottom unit in board (not counting rectangles)
adjacentSquareRightBottom(X,Y,Board,Adjacents,Xmore,Xless,Ymore,Yless):-
  getPiece(Xmore,Y,Board,Piece1),
  getTriangleDown(Xless,Y,Board,Piece2),
  getPiece(X,Ymore,Board,Piece4),
  getTriangleDown(X,Yless,Board,Piece3),
  append([  [[Y,Xmore],Piece1],  [[Y,Xless],Piece2], [ [Ymore,X], Piece3], [[Yless,X],Piece4]],[],Adjacents).

%adjacents of squares in case of bottom line in board (not counting rectangles)
adjacentSquareBottom(X,Y,Board,Adjacents,Xmore,Xless,Ymore,Yless):-
  getTriangleUp(Xmore,Y,Board,Piece1),
  getTriangleDown(Xless,Y,Board,Piece2),
  getPiece(X,Ymore,Board,Piece3),
  getTriangleDown(X,Yless,Board,Piece4),
  append([  [[Y,Xmore],Piece1],  [[Y,Xless],Piece2], [ [Ymore,X], Piece3], [[Yless,X],Piece4]],[],Adjacents).

%adjacents of squares in case of right column in board (not counting rectangles)
adjacentSquareRight(X,Y,Board,Adjacents,Xmore,Xless,Ymore,Yless):-
  getPiece(Xmore,Y,Board,Piece1),
  getTriangleDown(Xless,Y,Board,Piece2),
  getTriangleDown(X,Ymore,Board,Piece3),
  getTriangleUp(X,Yless,Board,Piece4),
  append([  [[Y,Xmore],Piece1],  [[Y,Xless],Piece2], [ [Ymore,X], Piece3], [[Yless,X],Piece4]],[],Adjacents).

%adjacents of squares in even rows
adjacentSquareEvenRows(X,Y,Board,Adjacents,Xmore,Xless,Ymore,Yless):-
  getTriangleUp(Xmore,Y,Board,Piece1),
  getTriangleDown(Xless,Y,Board,Piece2),
  getTriangleDown(X,Ymore,Board,Piece3),
  getTriangleUp(X,Yless,Board,Piece4),
  append([  [[Y,Xmore],Piece1],  [[Y,Xless],Piece2], [ [Ymore,X], Piece3], [[Ymore,X],Piece4]],[],Adjacents).

%adjacents of squares in odd rows
adjacentSquareOddRows(X,Y,Board,Adjacents,Xmore,Xless,Ymore,Yless):-
  getTriangleUp(Xmore,Y,Board,Piece1),
  getTriangleDown(Xless,Y,Board,Piece2),
  getTriangleUp(X,Ymore,Board,Piece3),
  getTriangleDown(X,Yless,Board,Piece4),
  append([  [[Y,Xmore],Piece1],  [[Y,Xless],Piece2], [ [Ymore,X], Piece3], [[Yless,X],Piece4]],[],Adjacents).

%adjacents of squares 
adjacentSquare(Board,X,Y,Adjacents):-
  Xless is X -1,
  Ymore is Y+1,
  Xmore is X +1,
  Yless is Y-1,
  Mod is X mod 2,
  ((X == 2, Y==2,
    adjacentSquareLeftTop(X,Y,Board,Adjacents,Xmore,Xless,Ymore,Yless));
  (X== 2,
    adjacentSquareLeft(X,Y,Board,Adjacents,Xmore,Xless,Ymore,Yless));
  (Y == 2,
    adjacentSquareTop(X,Y,Board,Adjacents,Xmore,Xless,Ymore,Yless));
  (X==9,Y==9,
    adjacentSquareRightBottom(X,Y,Board,Adjacents,Xmore,Xless,Ymore,Yless));
  (Y ==9,
    adjacentSquareBottom(X,Y,Board,Adjacents,Xmore,Xless,Ymore,Yless));
  (X==9,
    adjacentSquareRight(X,Y,Board,Adjacents,Xmore,Xless,Ymore,Yless));
  (Mod == 0,
    adjacentSquareEvenRows(X,Y,Board,Adjacents,Xmore,Xless,Ymore,Yless));
  adjacentSquareOddRows(X,Y,Board,Adjacents,Xmore,Xless,Ymore,Yless)).

%Adds to a list adjacent pieces of the ones already played on board
possiblePlaysAux(Board,[],PossiblePlaysOut,PossiblePlaysOut).
possiblePlaysAux(Board,[Piece|Rest],PossiblePlaysIn,PossiblePlaysOut):-
  [Coord|[Info|_]] = Piece,
  [X|[Y|_]] = Coord,
  [_|[Id|_]]= Info,
  lookForAdjacent(Board,X,Y,Id, Adjacents),
  append(Adjacents,PossiblePlaysIn,T),
  possiblePlaysAux(Board,Rest,T,PossiblePlaysOut).

%remove pieces from possible plays -
%used to remove pieces that were already played
removePiecesOnBoard([],List2,List2).
removePiecesOnBoard([Piece|Rest],List,List2):-
  delete(List,Piece,T),
  removePiecesOnBoard(Rest,T,List2).

%true if variable is not instanced
not_inst(Var):-
  \+(\+(Var=0)),
  \+(\+(Var=1)).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% GAME LOGIC %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% validPlay(X,Y,T,PossiblePlays):-
%   member([ [X,Y],[0,]       ])



%calculate next possible plays based on already played pieces(aux)
possiblePlays(Board,Aux,NoAux):-
  not_inst(Aux);                                             %case aux is not instanced
  (possiblePlaysAux(Board,Aux,[],PossiblePlaysOut),          %adds all adjacent pieces to the ones played on the board
  %remove_dups(PossiblePlaysOut,NoDups),
  removePiecesOnBoard(Aux,PossiblePlaysOut,NoAux)),          %removes from list of adjacents the pieces that were already played
  print('Possible Plays: '),print(NoAux).                    % shows to player possible plays

%add piece to auxiliar structure
addPlayAux(AuxIn,Board,X,Y,T, AuxOut):-
    switch(T,[
    -1:addAuxOther(X,Y,Board,AuxIn,AuxOut),
    0:addAuxTriangleDown(X,Y,Board,AuxIn,AuxOut),
    1:addAuxTriangleUp(X,Y,Board,AuxIn,AuxOut)
  ]).

%need to calculate for rectangles too
lookForAdjacent(Board,[Coord|[Info|_]],Adjacents):-
    (Info = [_|[Id|_]],
    Coord = [X|[Y|_]]),
    ((Id == 3, adjacentUp3(Board,X,Y,Adjacents));
    (Id == 4, adjacentDown4(Board,X,Y,Adjacents));
    (Id == 5, adjacentUp5(Board,X,Y,Adjacents));
    (Id == 6, adjacentDown6(Board,X,Y,Adjacents));
    (Id == 0,adjacentSquare(Board,X,Y,Adjacents))).
  

play(Player, Board, AuxIn, AuxOut,BoardOut):-  
    display_game(Board,Player),                     %display board
    possiblePlays(Board,AuxIn,NoAux),
    getPlayInfo(Col,Row,T), 
    getShapeAddCoord(Board,Row,Col,T,Piece),
    lookForAdjacent(Board,Piece,Adjacents),
    print(Adjacents),
    fillPiece(Board,Row,Col,T,Player,BoardOut),         %fill piece with player color
    addPlayAux(AuxIn,BoardOut,Col,Row,T, AuxOut).
    %game_state().

playsLoop(Board,Aux):-
    play(1,Board,Aux,Aux2,BoardOut).                %player1
    %play(2,BoardOut,Aux2,AuxF,BoardOut2).           %player2
    %playsLoop(BoardOut2,AuxF).                      

gameStart():-
    buildBlankList(L),                              %build board
    playsLoop(L,[]).                                

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% BOARDS SETUP %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
buildBlankList(L) :-
    append( [
        [ [0,1], [0,2], [0,2], [0,2], [0,2], [0,1], [0,1], [0,1], [0,1], [0,1] ], 
        [ [0,1], [0,0], [[0,5], [0,6]], [0,0], [[0,5],[0,6]], [0,0], [[0,5],[0,6]], [0,0], [[0,5],[0,6]], [0,2] ],
        [ [0,1], [[0,3],[0,4]], [0,0], [[0,3],[0,4]], [0,0], [[0,3],[0,4]], [0,0], [[0,3], [0,4]], [0,0], [0,2] ],
        [ [0,1], [0,0], [[0,5],[0,6]], [0,0], [[0,5],[0,6]], [0,0], [[0,5],[0,6]], [0,0], [[0,5], [0,6]], [0,2] ],        
        [ [0,1], [[0,3],[0,4]], [0,0], [[0,3],[0,4]], [0,0], [[0,3],[0,4]], [0,0], [[0,3], [0,4]], [0,0], [0,2] ],      
        [ [0,2], [0,0], [[0,5],[0,6]], [0,0], [[0,5],[0,6]], [0,0], [[0,5],[0,6]], [0,0], [[0,5],[0,6]], [0,2] ],
        [ [0,2], [[0,3],[0,4]], [0,0], [[0,3],[0,4]], [0,0], [[0,3],[0,4]], [0,0], [[0,3],[0,4]], [0,0], [0,2] ], 
        [ [0,2], [0,0], [[0,5],[0,6]], [0,0], [[0,5],[0,6]], [0,0], [[0,5],[0,6]], [0,0], [[0,5],[0,6]], [0,2] ],
        [ [0,2], [[0,3],[0,4]], [0,0], [[0,3],[0,4]], [0,0], [[0,3],[0,4]], [0,0], [[0,3],[0,4]], [0,0], [0,2] ],
        [ [0,1], [0,1], [0,1], [0,1], [0,1], [0,2], [0,2], [0,2], [0,2], [0,1] ]
    ],[],L).

%victory board for report
buildFinalList(L) :-
    append( [
        [ [0,1], [0,2], [0,2], [0,2], [0,2], [0,1], [0,1], [0,1], [0,1], [0,1] ], 
        [ [0,1], [0,0], [[0,5], [0,6]], [0,0], [[0,5],[0,6]], [0,0], [[0,5],[0,6]], [0,0], [[0,5],[0,6]], [0,2] ],
        [ [0,1], [[0,3],[0,4]], [0,0], [[0,3],[0,4]], [0,0], [[0,3],[2,4]], [0,0], [[0,3], [0,4]], [0,0], [0,2] ],
        [ [0,1], [0,0], [[0,5],[0,6]], [0,0], [[1,5],[2,6]], [1,0], [[0,5],[1,6]], [1,0], [[0,5], [0,6]], [0,2] ],        
        [ [0,1], [[0,3],[0,4]], [0,0], [[0,3],[0,4]], [2,0], [[1,3],[2,4]], [2,0], [[2,3], [1,4]], [0,0], [0,2] ],      
        [ [0,2], [0,0], [[0,5],[0,6]], [0,0], [[2,5],[0,6]], [1,0], [[1,5],[2,6]], [1,0], [[0,5],[0,6]], [0,2] ],
        [ [0,2], [[0,3],[0,4]], [0,0], [[0,3],[0,4]], [0,0], [[0,3],[0,4]], [0,0], [[2,3],[0,4]], [0,0], [0,2] ], 
        [ [0,2], [0,0], [[0,5],[0,6]], [0,0], [[0,5],[0,6]], [0,0], [[0,5],[0,6]], [0,0], [[0,5],[0,6]], [0,2] ],
        [ [0,2], [[0,3],[0,4]], [0,0], [[0,3],[0,4]], [0,0], [[0,3],[0,4]], [0,0], [[0,3],[0,4]], [0,0], [0,2] ],
        [ [0,1], [0,1], [0,1], [0,1], [0,1], [0,2], [0,2], [0,2], [0,2], [0,1] ]
    ],[],L).

    %intermediate board for report
buildIntList(L) :-
    append( [
        [ [0,1], [0,2], [0,2], [0,2], [0,2], [0,1], [0,1], [0,1], [0,1], [0,1] ], 
        [ [0,1], [0,0], [[0,5], [0,6]], [0,0], [[0,5],[0,6]], [0,0], [[0,5],[0,6]], [0,0], [[0,5],[0,6]], [0,2] ],
        [ [0,1], [[0,3],[0,4]], [0,0], [[0,3],[0,4]], [0,0], [[0,3],[2,4]], [0,0], [[0,3], [0,4]], [0,0], [0,2] ],
        [ [0,1], [0,0], [[0,5],[0,6]], [0,0], [[1,5],[2,6]], [1,0], [[1,5],[1,6]], [1,0], [[0,5], [0,6]], [0,2] ],        
        [ [0,1], [[0,3],[0,4]], [0,0], [[0,3],[0,4]], [2,0], [[1,3],[2,4]], [2,0], [[0,3], [0,4]], [0,0], [0,2] ],      
        [ [0,2], [0,0], [[0,5],[0,6]], [0,0], [[2,5],[0,6]], [1,0], [[1,5],[2,6]], [1,0], [[0,5],[0,6]], [0,2] ],
        [ [0,2], [[0,3],[0,4]], [0,0], [[0,3],[0,4]], [0,0], [[0,3],[0,4]], [0,0], [[2,3],[0,4]], [0,0], [0,2] ], 
        [ [0,2], [0,0], [[0,5],[0,6]], [0,0], [[0,5],[0,6]], [0,0], [[0,5],[0,6]], [0,0], [[0,5],[0,6]], [0,2] ],
        [ [0,2], [[0,3],[0,4]], [0,0], [[0,3],[0,4]], [0,0], [[0,3],[0,4]], [0,0], [[0,3],[0,4]], [0,0], [0,2] ],
        [ [0,1], [0,1], [0,1], [0,1], [0,1], [0,2], [0,2], [0,2], [0,2], [0,1] ]
    ],[],L).

    %start board for report
buildStartList(L) :-
    append( [
        [ [0,1], [0,2], [0,2], [0,2], [0,2], [0,1], [0,1], [0,1], [0,1], [0,1] ], 
        [ [0,1], [0,0], [[0,5], [0,6]], [0,0], [[0,5],[0,6]], [0,0], [[0,5],[0,6]], [0,0], [[0,5],[0,6]], [0,2] ],
        [ [0,1], [[0,3],[0,4]], [0,0], [[0,3],[0,4]], [0,0], [[0,3],[0,4]], [0,0], [[0,3], [0,4]], [0,0], [0,2] ],
        [ [0,1], [0,0], [[0,5],[0,6]], [0,0], [[0,5],[0,6]], [0,0], [[0,5],[0,6]], [0,0], [[0,5], [0,6]], [0,2] ],        
        [ [0,1], [[0,3],[0,4]], [0,0], [[0,3],[0,4]], [0,0], [[0,3],[2,4]], [0,0], [[0,3], [0,4]], [0,0], [0,2] ],      
        [ [0,2], [0,0], [[0,5],[0,6]], [0,0], [[0,5],[0,6]], [0,0], [[0,5],[0,6]], [0,0], [[0,5],[0,6]], [0,2] ],
        [ [0,2], [[0,3],[0,4]], [0,0], [[0,3],[0,4]], [0,0], [[0,3],[0,4]], [0,0], [[0,3],[0,4]], [0,0], [0,2] ], 
        [ [0,2], [0,0], [[0,5],[0,6]], [0,0], [[0,5],[0,6]], [0,0], [[0,5],[0,6]], [0,0], [[0,5],[0,6]], [0,2] ],
        [ [0,2], [[0,3],[0,4]], [0,0], [[0,3],[0,4]], [0,0], [[0,3],[0,4]], [0,0], [[0,3],[0,4]], [0,0], [0,2] ],
        [ [0,1], [0,1], [0,1], [0,1], [0,1], [0,2], [0,2], [0,2], [0,2], [0,1] ]
    ],[],L).


    buildTieList(L) :-
    append( [
        [ [0,1], [0,2], [0,2], [0,2], [0,2], [0,1], [0,1], [0,1], [0,1], [0,1] ], 
        [ [0,1], [0,0], [[0,5], [0,6]], [0,0], [[0,5],[0,6]], [0,0], [[0,5],[0,6]], [0,0], [[0,5],[0,6]], [0,2] ],
        [ [0,1], [[0,3],[0,4]], [0,0], [[0,3],[0,4]], [0,0], [[0,3],[0,4]], [0,0], [[0,3], [0,4]], [0,0], [0,2] ],
        [ [0,1], [0,0], [[0,5],[0,6]], [0,0], [[1,5],[1,6]], [2,0], [[2,5],[2,6]], [0,0], [[0,5], [0,6]], [0,2] ],        
        [ [0,1], [[0,3],[0,4]], [0,0], [[0,3],[1,4]], [2,0], [[1,3],[2,4]], [2,0], [[0,3], [0,4]], [0,0], [0,2] ],      
        [ [0,2], [0,0], [[0,5],[0,6]], [1,0], [[1,5],[1,6]], [2,0], [[2,5],[2,6]], [0,0], [[0,5],[0,6]], [0,2] ],
        [ [0,2], [[0,3],[0,4]], [0,0], [[0,3],[0,4]], [0,0], [[1,3],[0,4]], [0,0], [[0,3],[0,4]], [0,0], [0,2] ], 
        [ [0,2], [0,0], [[0,5],[0,6]], [0,0], [[0,5],[0,6]], [0,0], [[0,5],[0,6]], [0,0], [[0,5],[0,6]], [0,2] ],
        [ [0,2], [[0,3],[0,4]], [0,0], [[0,3],[0,4]], [0,0], [[0,3],[0,4]], [0,0], [[0,3],[0,4]], [0,0], [0,2] ],
        [ [0,1], [0,1], [0,1], [0,1], [0,1], [0,2], [0,2], [0,2], [0,2], [0,1] ]
    ],[],L).

fillPieceOther(TabIn,RowN,ColN,Player,TabOut) :-
  nth1(RowN,TabIn,Row,_), %retrieve row
  select(Row,TabIn,NewTab), %delete old row
  nth1(ColN,Row,[_|ID],NewRow), %retrieve column and piece ID
  nth1(ColN,NRow,[Player|ID],NewRow), %insert col into row
  nth1(RowN,TabOut,NRow,NewTab). % insert row into tab

fillPieceTriUp(TabIn,RowN,ColN,Player,TabOut):-
  nth1(RowN,TabIn,Row,_), %retrieve row
  select(Row,TabIn,NewTab), %delete old row
  nth1(ColN,Row,[[_,ID|_]|Rest],NewRow), %retrieve column and triangle piece ID
  nth1(ColN,NRow,[[Player,ID|_]|Rest],NewRow), %insert col into row
  nth1(RowN,TabOut,NRow,NewTab). % insert row into tab

fillPieceTriDwn(TabIn,RowN,ColN,Player,TabOut):-
  nth1(RowN,TabIn,Row,_), %retrieve row
  select(Row,TabIn,NewTab), %delete old row
  nth1(ColN,Row,[Rest,[_,ID|_]|_],NewRow), %retrieve column and triangle piece ID
  nth1(ColN,NRow,[Rest,[Player,ID|_]|_],NewRow), %insert col into row
  nth1(RowN,TabOut,NRow,NewTab).

fillPiece(TabIn,RowN,ColN,Tri,Fill,TabOut) :-
  switch(Tri,[
    -1:fillPieceOther(TabIn,RowN,ColN,Fill,TabOut),
    0:fillPieceTriUp(TabIn,RowN,ColN,Fill,TabOut),
    1:fillPieceTriDwn(TabIn,RowN,ColN,Fill,TabOut)
  ]).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Verify Game State %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%verifyAdjPieceState(+TabIn,+Player,+Adj,+InPlay,-InPlay2,-TabOut,-PieceState)
%Very similar to verifyPieceState/6, except that recieves a piece to check externally
%to the pieces in play and then removes it from the list
verifyAdjPieceState(TabIn,Player,Adj,InPlay,InPlay2,TabOut,PieceState) :-
  Adj = [[Row,Col],[_,ID]],
  lookForAdjacent(TabIn,Col,Row,ID,Adjs),
  checkAdjs(Adjs,Player,AdjcentTo,[],Result),
  isTri(ID,Tri),
  getOposPlayer(Player,Opos),
  ((Result == 0, InPlay2 = InPlay, fillPiece(TabIn,Row,Col,Tri,0,TabOut), PieceState = 0);
  (Result == 1, fillPiece(TabIn,Row,Col,Tri,Opos,AuxTab), select(Adj,InPlay,InPlayO), processAdjs(AuxTab,Player,AdjcentTo,InPlayO,InPlay2,TabOut,PieceState));
  (Result == 2, PieceState = 1, TabOut = TabIn)).


%processAdjs(+TabIn,+Player,+Adjs,+Inplay,-InPlay2,-TabOut,-PieceState)
%Process adjacents of a piece sequentially, and if one of them is free then the main piece
%is free. Otherwise, if the processing reaches its end, it means the block is trapped
processAdjs(TabOut,_,[],_,_,TabOut,1).

processAdjs(TabIn,Player,[Adj|Rest],InPlay,InPlay2,TabOut,PieceState):-
  verifyAdjPieceState(TabIn,Player,Adj,InPlay,InplayO,AuxTab,PieceResult),
  ((PieceResult == 0, PieceState = 0, TabOut = AuxTab);
  processAdjs(AuxTab,Player,Rest,InplayO,InPlay2,TabOut,PieceState)).
  
%checkAdjs(+Adjs,+Player,-AdjacentTo,?Temp,-Result)
%To check adjacents, we check if piece is empty or belongs to the player (and/or rectangle),
%Save adjacent pieces of the same player in a list and determine the result in the end
%Result: 0 - Piece is safe 1 - Piece has adjacents of the same player 2 - Piece is surrounded
checkAdjs(List,_,Temp,Temp,Result):-
  List == [],(Temp == [], Result = 2; Result = 1).

checkAdjs([Piece|Rest],Player, AdjcentTo,Temp,Result):-
  Piece = [_,[Fill,Type]],
  (((Fill == 0; (Fill == Player, (Type == 1; Type == 2))), Result = 0);
  (Fill == Player, append(Temp,[Piece],TempN), checkAdjs(Rest,Player,AdjcentTo,TempN,Result));
  checkAdjs(Rest,Player,AdjcentTo,Temp,Result)).

%verifyPieceState(+TabIn,+Player,+InPlay,-InPlay2,-TabOut,-PieceState)
%To verify a piece state, get adjacents, check them, and analyze adjacent pieces of the same player
%With a DFS-like solution
%PieceState: 0 - Piece is safe 1 - Piece or block is surrounded
verifyPieceState(TabIn,Player,[Piece|Rest],InPlay2,TabOut,PieceState) :-
  Piece = [[Row,Col],[Fill,ID]],
  ((\+(Fill == Player), InPlay2 = Rest, TabOut = TabIn, PieceState = 0);
  (lookForAdjacent(TabIn,Col,Row,ID,Adjs),
  checkAdjs(Adjs,Player,AdjcentTo,[],Result),
  isTri(ID,Tri),
  getOposPlayer(Player,Opos),
  ((Result == 0, InPlay2 = Rest, fillPiece(TabIn,Row,Col,Tri,0,TabOut), PieceState = 0);
  (Result == 1, fillPiece(TabIn,Row,Col,Tri,Opos,AuxTab), processAdjs(AuxTab,Player,AdjcentTo,Rest,InPlay2,TabOut,PieceState));
  (Result == 2, PieceState = 1,TabOut = TabIn)))).  

%verifyPlayerState(+TabIn,+Player,+InPlay,-StateOut)
%To verify the player's state, verify all pieces in play in order to check 
%if some piece/pieces belonging to the player is surrounded
%StateOut: 0 - Player continues; 1 - Player loses
verifyPlayerState(_,_,[],0).
verifyPlayerState(TabIn,Player,InPlay,StateOut) :-
  verifyPieceState(TabIn,Player, InPlay, InPlay2, AuxTab, PieceState),
  ((PieceState == 0, verifyPlayerState(AuxTab,Player,InPlay2,StateOut));
  (PieceState == 1, display_game(TabIn,1), StateOut = 1)).

%verifyGameState(+TabIn,+InPlay,-StateOut)
%To verify game state, verify if player 1 and player 2 has some piece/pieces surrounded
% StateOut: 0 - continue; 1- Player 1 wins; 2- Player 2 wins; 3- Tie game
verifyGameState(TabIn,InPlay,StateOut) :-
  verifyPlayerState(TabIn,1,InPlay,P1State), 
  verifyPlayerState(TabIn,2,InPlay,P2State), 
  ((P1State == 0, P2State == 0, StateOut = 0);
  (P1State == 0, P2State == 1, StateOut = 1);
  (P1State == 1, P2State == 0, StateOut = 2);
  (P1State == 1, P2State == 1, StateOut = 3)).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TESTING %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

fillOne(X) :-
    buildBlankList(L),
    display_game(L,2),
    fillPieceTriDwn(L,3,2,1,L2),
    getPieceFill(L2,3,3,0,X),
    display_game(L2,1).

lookAdjsTest(Adjs,Row,Col,ID) :-
  buildIntList(L),
  display_game(L,1),
  lookForAdjacent(L,Col,Row,ID,Adjs).

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

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 