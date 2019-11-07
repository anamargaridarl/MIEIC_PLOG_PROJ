%____________________ Adjacent Pieces - help functions ________________________________%

%get piece full info
getFullPiece(X,Y,Board,[[Y,X],Info]) :-
  getPiece(X,Y,Board,Info).

%get piece from board based on X and Y position
getPiece(X,Y,Board,Piece):-
  nth1(Y,Board,Row,_),
  nth1(X,Row,Piece,_).

%get shape 
getShapeAddCoord(Board,Row,Col,Tri,Piece) :-
  switch(Tri,[
    -1:getPiece(Row,Col,Board,PieceAux),
    0:getTriangleUp(Col,Row,Board,PieceAux),
    1:getTriangleDown(Col,Row,Board,PieceAux)
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
  Xless is X-1,
  Yless is Y-1,
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
