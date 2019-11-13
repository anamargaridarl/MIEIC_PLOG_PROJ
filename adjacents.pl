%____________________ Adjacent Pieces - help functions ________________________________%

%adjacents to triangle5
adjacentUp5(Board,X,Y,Adjacents):-
  Xmore is X +1,
  Yless is Y-1,
  getPiece(Xmore,Y,Board,Piece1), %este
  getTriangleDown(X,Y,Board,Piece2),
  getPiece(X,Yless,Board,Piece3), %este
   ((isRectangle(Piece1,Id),isRectangle(Piece3,Id),
  adjRect(Board,Y,Id,Xmore,Pieces1,Piece1),
  adjRect(Board,Yless,Id,X,Pieces2,Piece3),
  append(Pieces1,Pieces2,Aux),
  append([ [[Y,X],Piece2] ] ,Aux,Adjacents));
  (isRectangle(Piece1,Id),
  adjRect(Board,Y,Id,Xmore,Pieces1,Piece1),
  append([ [[Y,X],Piece2] , [[X,Yless],Piece3] ] ,Pieces1,Adjacents));
  (isRectangle(Piece3,Id),
  adjRect(Board,Yless,Id,X,Pieces1,Piece3),
  append([ [[Y,X],Piece2] , [[Xmore,Y],Piece1] ] ,Pieces1,Adjacents));
  append([  [[Y,Xmore],Piece1],  [[Y,X],Piece2], [ [Yless,X], Piece3]],[],Adjacents)).

%adjacents to triangle3
adjacentUp3(Board,X,Y,Adjacents):-
  Xless is X-1,
  Yless is Y-1,
  getPiece(Xless,Y,Board,Piece1),
  getTriangleDown(X,Y,Board,Piece2),
  getPiece(X,Yless,Board,Piece3),
  ((isRectangle(Piece1,Id),
  adjRect(Board,Y,Id,Xless,Pieces,Piece1),
  append([ [[Y,X],Piece2], [ [Yless,X], Piece3]],Pieces,Adjacents));
  append([  [[Y,Xless],Piece1],  [[Y,X],Piece2], [ [Yless,X], Piece3]],[],Adjacents)).

%adjacents to triangle4
adjacentDown4(Board,X,Y,Adjacents):-
  Xmore is X +1,
  Ymore is Y+1,
  getPiece(Xmore,Y,Board,Piece1),
  getTriangleUp(X,Y,Board,Piece2),
  getPiece(X,Ymore,Board,Piece3),
  ((isRectangle(Piece3,Id),
  adjRect(Board,Ymore,Id,X,Pieces,Piece3),
  append([  [[Y,Xmore],Piece1],[[Y,X],Piece2]],Pieces,Adjacents));
  append([  [[Y,Xmore],Piece1],  [[Y,X],Piece2], [ [Ymore,X], Piece3]],[],Adjacents)).

%adjacent to triangle6
adjacentDown6(Board,X,Y,Adjacents):-
  Xless is X -1,
  Ymore is Y+1,
  getPiece(Xless,Y,Board,Piece1),
  getTriangleUp(X,Y,Board,Piece2),
  getPiece(X,Ymore,Board,Piece3),
  append([  [[Y,Xless],Piece1],  [[Y,X],Piece2], [ [Ymore,X], Piece3]],[],Adjacents).

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
  getTriangleUp(X,Ymore,Board,Piece3),
  getPiece(X,Yless,Board,Piece4),
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
  getTriangleDown(Xmore,Y,Board,Piece1),
  getTriangleUp(Xless,Y,Board,Piece2),
  getTriangleUp(X,Ymore,Board,Piece3),
  getTriangleDown(X,Yless,Board,Piece4),
  append([  [[Y,Xmore],Piece1],  [[Y,Xless],Piece2], [ [Ymore,X], Piece3], [[Yless,X],Piece4]],[],Adjacents).

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


adjRectVert(_,Row,Col,ID,IDB,PiecesOutA,PiecesOut,Piece)  :-
  (Row @< 1; Row @>10; ID \= IDB; member([[Row,Col],Piece],PiecesOutA)),
  PiecesOut = PiecesOutA.

adjRectVert(Board,Row,Col,Id,Id,Pieces,PiecesOut,Piece) :-
  append( [[[Row,Col],Piece]] ,Pieces,PiecesAux),
  RowB is Row - 1,
  RowA is Row + 1,
  (RowB @< 1; 
  RowA @> 10;
  (getPiece(Col,RowA,Board,Piece1),
  getId(Piece1,IdA),
  getPiece(Col,RowB,Board,Piece2),
  getId(Piece2,IdB))),
  adjRectVert(Board,RowA,Col,Id,IdA,PiecesAux,PiecesOut2,Piece1),
  adjRectVert(Board,RowB,Col,Id,IdB,PiecesOut2,PiecesOut,Piece2).

adjRectHorz(_,Row,Col,ID,IDB,PiecesOutA,PiecesOut,Piece) :-
  (Col @< 1; Col @>10; ID \= IDB; member([[Row,Col],Piece],PiecesOutA)),
  PiecesOut = PiecesOutA.

adjRectHorz(Board,Row,Col,Id,Id,Pieces,PiecesOut,Piece) :-
  append(  [[[Row,Col],Piece]] ,Pieces, PiecesAux),
  ColB is Col - 1,
  ColA is Col + 1,
  (ColB @< 1; 
  ColA @> 10;
  (getPiece(ColA,Row,Board,Piece1),
  getId(Piece1,IdA),
  getPiece(ColB,Row,Board,Piece2),
  getId(Piece2,IdB))),
  adjRectHorz(Board,Row,ColA,Id,IdA,PiecesAux,PiecesOut2,Piece1),
  adjRectHorz(Board,Row,ColB,Id,IdB,PiecesOut2,PiecesOut,Piece2).


adjRect(Board,Row,Id,Col,Pieces,Piece1) :-
  ((Row == 1, Col \= 1, adjRectHorz(Board,Row,Col,Id,Id,[],PiecesAux,Piece1));
  (Row == 10, Col \= 10,  adjRectHorz(Board,Row,Col,Id,Id,[],PiecesAux,Piece1));
 adjRectVert(Board,Row,Col,Id,Id,[],PiecesAux,Piece1)),
  append(PiecesAux,[],Pieces).


adjRect1(Board,Adjacents):-
    X is 2,
    getPiece(X,2,Board,Piece1),
    getTriangleUp(X,3,Board,Piece2),
    getPiece(X,4,Board,Piece3),
    getTriangleUp(X,5,Board,Piece4),
    getPiece(X,1,Board,Piece5),
    adjRect(Board,1,2,X,Pieces1,Piece5),
    getPiece(1,6,Board,Piece6),
    adjRect(Board,6,2,1,Pieces2,Piece6),
    append(Pieces1,Pieces2,Aux),
    append([ [[2,X],Piece1], [ [3,X], Piece2], [[4,X],Piece3],[[5,X],Piece4] ],Aux,Adjacents).

adjRect2(Board,Adjacents):-
    Y is 2,
    getPiece(2,Y,Board,Piece1),
    getTriangleUp(3,Y,Board,Piece2),
    getPiece(4,Y,Board,Piece3),
    getTriangleUp(5,Y,Board,Piece4),
    getPiece(1,1,Board,Piece5),
    adjRect(Board,1,1,1,Pieces1,Piece5),
    getPiece(6,1,Board,Piece6),
    adjRect(Board,1,1,6,Pieces2,Piece6),
    append(Pieces1,Pieces2,Aux),
    append([  [[Y,2],Piece1],  [[Y,3],Piece2], [ [Y,4], Piece3], [[Y,5],Piece4]],Aux,Adjacents).


adjRect3(Board,Adjacents):-
    Y is 2,
    getPiece(6,Y,Board,Piece1),
    getTriangleUp(7,Y,Board,Piece2),
    getPiece(8,Y,Board,Piece3),
    getTriangleUp(9,Y,Board,Piece4),
    getPiece(10,Y,Board,Piece5),
    adjRect(Board,Y,2,10,Pieces1,Piece5),
    getPiece(5,1,Board,Piece6),
    adjRect(Board,1,2,5,Pieces2,Piece6),
    append(Pieces1,Pieces2,Aux),
    append([  [[Y,6],Piece1],  [[Y,7],Piece2], [ [Y,8], Piece3], [[Y,9],Piece4]],Aux,Adjacents).

adjRect4(Board,Adjacents):-
    X is 9,
    getTriangleUp(X,2,Board,Piece1),
    getPiece(X,3,Board,Piece2),
    getTriangleUp(X,4,Board,Piece3),
    getPiece(X,5,Board,Piece4),
    getPiece(10,1,Board,Piece5),
    adjRect(Board,1,1,1,Pieces1,Piece5),
    getPiece(10,6,Board,Piece6),
    adjRect(Board,1,1,1,Pieces2,Piece6),
    append(Pieces1,Pieces2,Aux),
    append([  [[2,X],Piece1],  [[3,X],Piece2], [ [4,X], Piece3], [[5,X],Piece4],[[1,10],Piece5]],Aux,Adjacents).

adjRect5(Board,Adjacents):-
    X is 9,
    getTriangleUp(X,6,Board,Piece1),
    getPiece(X,7,Board,Piece2),
    getTriangleUp(X,8,Board,Piece3),
    getPiece(X,9,Board,Piece4),
    getPiece(X,10,Board,Piece5),
    adjRect(Board,10,2,X,Pieces1,Piece5),
    getPiece(10,5,Board,Piece6),
    adjRect(Board,5,2,10,Pieces2,Piece6),
    append(Pieces1,Pieces2,Aux),
    append([  [[6,X],Piece1],  [[7,X],Piece2], [ [8,X], Piece3], [[9,X],Piece4]],Aux,Adjacents).

adjRect6(Board,Adjacents):-
    Y is 9,
    getTriangleDown(6,Y,Board,Piece1),
    getPiece(7,Y,Board,Piece2),
    getTriangleDown(8,Y,Board,Piece3),
    getPiece(9,Y,Board,Piece4),
    getPiece(10,10,Board,Piece5),
    adjRect(Board,10,1,10,Pieces1,Piece5),
    getPiece(5,10,Board,Piece6),
    adjRect(Board,10,1,5,Pieces2,Piece6),
    append(Pieces1,Pieces2,Aux),
    append([  [[Y,6],Piece1],  [[Y,7],Piece2], [ [Y,8], Piece3], [[Y,9],Piece4]],Aux,Adjacents).

adjRect7(Board,Adjacents):-
    Y is 9,
    getTriangleDown(2,Y,Board,Piece1),
    getPiece(3,Y,Board,Piece2),
    getTriangleUp(4,Y,Board,Piece3),
    getPiece(5,Y,Board,Piece4),
    getPiece(1,Y,Board,Piece5),
    adjRect(Board,Y,2,1,Pieces1,Piece5),
    getPiece(6,10,Board,Piece6),
    adjRect(Board,10,2,6,Pieces2,Piece6),
    append(Pieces1,Pieces2,Aux),
    append([  [[Y,2],Piece1],  [[Y,3],Piece2], [ [Y,4], Piece3], [[Y,5],Piece4]],Aux,Adjacents).


adjRect8(Board,Adjacents):-
    X is 2,
    getPiece(X,6,Board,Piece1),
    getTriangleUp(X,7,Board,Piece2),
    getPiece(X,8,Board,Piece3),
    getTriangleUp(X,9,Board,Piece4),
    getPiece(1,10,Board,Piece5),
    adjRect(Board,10,1,1,Pieces1,Piece5),
    getPiece(1,5,Board,Piece6),
    adjRect(Board,5,1,1,Pieces2,Piece6),
    append(Pieces1,Pieces2,Aux),
    append([  [[6,X],Piece1],  [[7,X],Piece2], [ [8,X], Piece3], [[9,X],Piece4]],Aux,Adjacents).

%adjacents of rectangles 
adjacentRectangle(Board,X,Y,Adjacents):-

  ((X == 1, Y < 6,
    adjRect1(Board,Adjacents));
  (X== 1, Y >= 6, Y < 10,
    adjRect8(Board,Adjacents));
  (Y == 1, X < 6,
    adjRect2(Board,Adjacents));
  (Y == 1, X >= 6,
    adjRect3(Board,Adjacents));
  (X == 10, Y < 6,
    adjRect4(Board,Adjacents));
  (X == 10, Y >= 6,
    adjRect5(Board,Adjacents));
  (Y == 10, X < 6,
    adjRect7(Board,Adjacents));
  (Y == 10, X >= 6,
    adjRect6(Board,Adjacents))    
    ).