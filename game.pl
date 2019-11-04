%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% INCLUDE FILES %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
:- consult('boardDisplay.pl').
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
  (ID == 1; ID == 2),Tri is -1;
  (ID == 3; ID == 5), Tri is 0;
  (ID == 4; ID == 6), Tri is 1.

getOposPlayer(Player,Opos) :-
  (Player == 1, Opos is 2);
  (Player == 2, Opos is 1).

%___________________Auxiliar structure helper functions _______________________%

%add other pieces to auxiliar structure
addAuxOther(X,Y,Board,AuxIn,AuxOut):-
    nth1(Y,Board,Row,_),                           %get row
    nth1(X,Row,Piece,_),                           %get piece
    append([[[X,Y],Piece]], AuxIn, AuxOut).        %add to auxiliar structure

%add triangle up to auxiliar structure
addAuxTriangleUp(X,Y,Board,AuxIn,AuxOut):-
  getTriangleUp(X,Y,Board,Piece),          
  append([[[X,Y],Piece]], AuxIn, AuxOut).

%add triangle down to auxiliar structure
addAuxTriangleDown(X,Y,Board,AuxIn,AuxOut):-
  getTriangleDown(X,Y,Board,Piece),
  append([[[X,Y],Piece]], AuxIn, AuxOut).

%____________________ Adjacent Pieces _____________________________________________%

%get piece from board based on X and Y position
getPiece(X,Y,Board,Piece):-
  nth1(Y,Board,Row,_),
  nth1(X,Row,Piece,_).

%adjacents to triangle5
adjacentUp5(Board,X,Y,Adjacents):-
  Xmore is X +1,
  Ymore is Y+1,
  getPiece(Xmore,Y,Board,Piece1),
  getTriangleDown(X,Y,Board,Piece2),
  getPiece(X,Ymore,Board,Piece3),
  append([  [[Xmore,Y],Piece1],  [[X,Y],Piece2], [ [X,Ymore], Piece3]],[],Adjacents).

%adjacents to triangle3
adjacentUp3(Board,X,Y,Adjacents):-
  Xless is X -1,
  Ymore is Y +1,
  getPiece(Xless,Y,Board,Piece1),  
  getTriangleDown(X,Y,Board,Piece2),
  getPiece(X,Ymore,Board,Piece3),
  append([  [[Xless,Y],Piece1],  [[X,Y],Piece2], [ [X,Ymore], Piece3]],[],Adjacents).

%adjacents to triangle4
adjacentDown4(Board,X,Y,Adjacents):-
  Xmore is X +1,
  Yless is Y-1,
  getPiece(Xmore,Y.Board,Piece1),
  getTriangleUp(X,Y,Board,Piece2),
  getPiece(X,Yless,Board,Piece3),
  append([  [[Xmore,Y],Piece1],  [[X,Y],Piece2], [ [X,Yless], Piece3]],[],Adjacents).

%adjacent to triangle6
adjacentDown6(Board,X,Y,Adjacents):-
  Xless is X -1,
  Yless is Y-1,
  getPiece(Xless,Y,Board,Piece1),
  getTriangleUp(X,Y,Board,Piece2),
  getPiece(X,Yless,Board,Piece3),
  append([  [[Xless,Y],Piece1],  [[X,Y],Piece2], [ [X,Yless], Piece3]],[],Adjacents).

%adjacents of squares in case of left top unit in board (not counting rectangles)
adjacentSquareLeftTop(X,Y,Board,Adjacents,Xmore,Xless,Ymore,Yless):-
  getTriangleDown(Xmore,Y,Board,Piece1),
  getPiece(Xless,Y,Board,Piece2),
  getTriangleUp(X,Ymore,Board,Piece4),
  getPiece(X,Yless,Board,Piece3),
  append([  [[Xmore,Y],Piece1],  [[Xless,Y],Piece2], [ [X,Ymore], Piece3], [[X,Yless],Piece4]],[],Adjacents).

%adjacents of squares in case of left column in board (not counting rectangles)
adjacentSquareLeft(X,Y,Board,Adjacents,Xmore,Xless,Ymore,Yless):-
  getTriangleDown(Xmore,Y,Board,Piece1),
  getPiece(Xless,Y,Board,Piece2),
  getTriangleDown(X,Ymore,Board,Piece3),
  getTriangleUp(X,Yless,Board,Piece4),
  append([  [[Xmore,Y],Piece1],  [[Xless,Y],Piece2], [ [X,Ymore], Piece3], [[X,Yless],Piece4]],[],Adjacents).

%adjacents of squares in case of top line in board (not counting rectangles)
adjacentSquareTop(X,Y,Board,Adjacents,Xmore,Xless,Ymore,Yless):-
  getTriangleDown(Xmore,Y,Board,Piece1),
  getTriangleUp(Xless,Y,Board,Piece2),
  getTriangleUp(X,Ymore,Board,Piece4),
  getPiece(X,Yless,Board,Piece3),
  append([  [[Xmore,Y],Piece1],  [[Xless,Y],Piece2], [ [X,Ymore], Piece3], [[X,Yless],Piece4]],[],Adjacents).

%adjacents of squares in case of right bottom unit in board (not counting rectangles)
adjacentSquareRightBottom(X,Y,Board,Adjacents,Xmore,Xless,Ymore,Yless):-
  getPiece(Xmore,Y,Board,Piece1),
  getTriangleDown(Xless,Y,Board,Piece2),
  getPiece(X,Ymore,Board,Piece4),
  getTriangleDown(X,Yless,Board,Piece3),
  append([  [[Xmore,Y],Piece1],  [[Xless,Y],Piece2], [ [X,Ymore], Piece3], [[X,Yless],Piece4]],[],Adjacents).

%adjacents of squares in case of bottom line in board (not counting rectangles)
adjacentSquareBottom(X,Y,Board,Adjacents,Xmore,Xless,Ymore,Yless):-
  getTriangleUp(Xmore,Y,Board,Piece1),
  getTriangleDown(Xless,Y,Board,Piece2),
  getPiece(X,Ymore,Board,Piece3),
  getTriangleDown(X,Yless,Board,Piece4),
  append([  [[Xmore,Y],Piece1],  [[Xless,Y],Piece2], [ [X,Ymore], Piece3], [[X,Yless],Piece4]],[],Adjacents).

%adjacents of squares in case of right column in board (not counting rectangles)
adjacentSquareRight(X,Y,Board,Adjacents,Xmore,Xless,Ymore,Yless):-
  getPiece(Xmore,Y,Board,Piece1),
  getTriangleDown(Xless,Y,Board,Piece2),
  getTriangleDown(X,Ymore,Board,Piece3),
  getTriangleUp(X,Yless,Board,Piece4),
  append([  [[Xmore,Y],Piece1],  [[Xless,Y],Piece2], [ [X,Ymore], Piece3], [[X,Yless],Piece4]],[],Adjacents).

%adjacents of squares in even rows
adjacentSquareEvenRows(X,Y,Board,Adjacents,Xmore,Xless,Ymore,Yless):-
  getTriangleUp(Xmore,Y,Board,Piece1),
  getTriangleDown(Xless,Y,Board,Piece2),
  getTriangleDown(X,Ymore,Board,Piece3),
  getTriangleUp(X,Yless,Board,Piece4),
  append([  [[Xmore,Y],Piece1],  [[Xless,Y],Piece2], [ [X,Ymore], Piece3], [[X,Yless],Piece4]],[],Adjacents).

%adjacents of squares in odd rows
adjacentSquareOddRows(X,Y,Board,Adjacents,Xmore,Xless,Ymore,Yless):-
  getTriangleUp(Xmore,Y,Board,Piece1),
  getTriangleDown(Xless,Y,Board,Piece2),
  getTriangleDown(X,Ymore,Board,Piece3),
  getTriangleUp(X,Yless,Board,Piece4),
  append([  [[Xmore,Y],Piece1],  [[Xless,Y],Piece2], [ [X,Ymore], Piece3], [[X,Yless],Piece4]],[],Adjacents).

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

%calculate possible plays

possiblePlays(Board,[],PossiblePlays).
possiblePlays(Board,[Piece|Rest],Adjacents,PossiblePlaysIn,PossiblePlaysOut):-
  [Coord|[Info|_]] = Piece,
  [X|[Y|_]] = Coord,
  [_|[Id|_]]= Info,
  lookForAdjacent(Board,X,Y,Id, Adjacents),
  append(Adjacents,PossiblePlaysIn,PossiblePlaysOut),
  possiblePlays(Board,Rest,PossiblePlaysOut,PossiblePlays).

test():-
append([ [[3,3],[0,0]] , [[4,3],[0,3]] ],[],Aux),
buildBlankList(Board),
possiblePlays(Board,Aux,[],PossiblePlaysOut),
print(PossiblePlaysOut).



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% GAME LOGIC %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%add piece to auxiliar structure
addPlayAux(AuxIn,Board,X,Y,T, AuxOut):-
    atom_number(Y,NY),
    switch(T,[
    -1:addAuxOther(X,NY,Board,AuxIn,AuxOut),
    0:addAuxTriangleDown(X,NY,Board,AuxIn,AuxOut),
    1:addAuxTriangleUp(X,NY,Board,AuxIn,AuxOut)
  ]).

%need to calculate for rectangles too
lookForAdjacent(Board,X,Y,Id,Adjacents):-
    ((Id == 3, adjacentUp3(Board,X,Y,Adjacents));
    (Id == 4, adjacentDown4(Board,X,Y,Adjacents));
    (Id == 5, adjacentUp5(Board,X,Y,Adjacents));
    (Id == 6, adjacentDown6(Board,X,Y,Adjacents));
    (Id == 0,adjacentSquare(Board,X,Y,Adjacents))).
  
play(Player, Board, AuxIn, AuxOut,BoardOut):- 
    display_game(Board,Player),                     %display board
    getPlayInfo(X,Y,T), 
    lookForAdjacent(Board,X,Y,0,Adjacents),
    print(Adjacents),
    fillPiece(Board,Y,X,T,Player,BoardOut),         %fill piece with player color
    addPlayAux(AuxIn,BoardOut,X,Y,T, AuxOut).       %add play to auxiliar structure
    %game_state().

playsLoop(Board,Aux):-
    play(1,Board,Aux,Aux2,BoardOut).             %player1
    %play(2,BoardOut,Aux2,AuxF,BoardOut2),           %player2
    % print(AuxF).         
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
        [ [0,1], [[0,3],[0,4]], [0,0], [[0,3],[1,4]], [1,0], [[1,3],[2,4]], [2,0], [[0,3], [0,4]], [0,0], [0,2] ],      
        [ [0,2], [0,0], [[0,5],[0,6]], [1,0], [[1,5],[1,6]], [2,0], [[2,5],[2,6]], [0,0], [[0,5],[0,6]], [0,2] ],
        [ [0,2], [[0,3],[0,4]], [0,0], [[0,3],[0,4]], [0,0], [[1,3],[0,4]], [0,0], [[0,3],[0,4]], [0,0], [0,2] ], 
        [ [0,2], [0,0], [[0,5],[0,6]], [0,0], [[0,5],[0,6]], [0,0], [[0,5],[0,6]], [0,0], [[0,5],[0,6]], [0,2] ],
        [ [0,2], [[0,3],[0,4]], [0,0], [[0,3],[0,4]], [0,0], [[0,3],[0,4]], [0,0], [[0,3],[0,4]], [0,0], [0,2] ],
        [ [0,1], [0,1], [0,1], [0,1], [0,1], [0,2], [0,2], [0,2], [0,2], [0,1] ]
    ],[],L).

fillPieceOther(TabIn,RowN,ColN,Player,TabOut) :-
  atom_number(RowN,RowAuxN),
  nth1(RowAuxN,TabIn,Row,_), %retrieve row
  select(Row,TabIn,NewTab), %delete old row
  nth1(ColN,Row,[_|ID],NewRow), %retrieve column and piece ID
  nth1(ColN,NRow,[Player|ID],NewRow), %insert col into row
  nth1(RowAuxN,TabOut,NRow,NewTab). % insert row into tab

fillPieceTriUp(TabIn,RowN,ColN,Player,TabOut):-
  atom_number(RowN,RowNN),
  nth1(RowNN,TabIn,Row,_), %retrieve row
  select(Row,TabIn,NewTab), %delete old row
  nth1(ColN,Row,[[_,ID|_]|Rest],NewRow), %retrieve column and triangle piece ID
  nth1(ColN,NRow,[[Player,ID|_]|Rest],NewRow), %insert col into row
  nth1(RowNN,TabOut,NRow,NewTab). % insert row into tab

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
  
fillOne(X) :-
    buildBlankList(L),
    display_game(L,2),
    fillPieceTriDwn(L,3,2,1,L2),
    getPieceFill(L2,3,3,0,X),
    display_game(L2,1).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Verify Game State %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%To Implement
processAdjs(_,_,_,_,_,_,_).

%checkAdjs(+Adjs,+Player,-AdjacentTo,?Temp,-Result)
%To check adjacents, we check if piece is empty or belongs to the player,
%Save adjacent pieces of the same player in a list and determine the result in the end
checkAdjs(List,Adjs,Temp,Temp,Result):-
  List == [],(Adjs == [], Result is 2; Result is 1).

checkAdjs([Piece|Rest],Player, AdjcentTo,Temp,Result):-
  Piece = [_,[Fill,_]],
  (Fill is 0 -> Result is 0;
  (Fill is Player -> append(Temp,[Piece],TempN),
  checkAdjs(Rest,Player,AdjcentTo,TempN,Result))).

%verifyPieceState(+TabIn,+Player,+InPlay,-InPlay2,-TabOut,-PieceState)
%To verify a piece state, get adjacents, check them, and analyze adjacent pieces of the same player
%With a DFS-like solution
%PieceState: 0 - Piece is safe 1 - Piece or block is surrounded
verifyPieceState(TabIn,Player,[Piece|Rest],InPlay2,TabOut,PieceState) :-
  Piece = [[Row,Col],[Fill,ID]],
  ((\+(Fill is Player), InPlay2 = Rest, TabOut = TabIn, PieceState = 0);
  lookForAdjacent(TabIn,Piece,Adjs),
  checkAdjs(Adjs,Player,AdjcentTo,[],Result),
  isTri(ID,Tri),
  getOposPlayer(Player,Opos),
  switch(Result, [
    0: (InPlay2 = Rest, fillPiece(TabIn,Row,Col,Tri,0,TabOut), PieceState = 0),
    1: (fillPiece(TabIn,Row,Col,Tri,Opos,AuxTab), processAdjs(AuxTab,Player,Rest,AdjcentTo,InPlay2,TabOut,PieceState)),
    2: PieceState = 1
  ])).  

%verifyPlayerState(+TabIn,+Player,+InPlay,-StateOut)
%To verify the player's state, verify all pieces in play in order to check 
%if some piece/pieces belonging to the player is surrounded
%StateOut: 0 - Player continues; 1 - Player loses
verifyPlayerState(_,_,[],0).
verifyPlayerState(TabIn,Player,InPlay,StateOut) :-
  verifyPieceState(TabIn,Player, InPlay, [], InPlay2, AuxTab, PieceState),
  (PieceState is 0 -> verifyPlayerState(AuxTab,Player,InPlay2,StateOut); StateOut is 1).

%verifyGameState(+TabIn,+InPlay,-StateOut)
%To verify game state, verify if player 1 and player 2 has some piece/pieces surrounded
% StateOut: 0 - continue; 1- Player 1 wins; 2- Player 2 wins; 3- Tie game
verifyGameState(TabIn,InPlay,StateOut) :-
  verifyPlayerState(TabIn,1,InPlay,P1State), 
  verifyPlayerState(TabIn,2,InPlay,P2State), 
  (P1State is 0 -> (P2State is 0 -> StateOut is 0; StateOut is 1 );
  (P1State is 1 -> (P2State is 0 -> StateOut is 2; StateOut is 3))).
