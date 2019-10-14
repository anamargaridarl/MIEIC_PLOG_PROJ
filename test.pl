%----------------------
drawHorizontalLine(0).
drawHorizontalLine(X):-
    X1 is X-1,put_char('-'),drawHorizontalLine(X1).

%|     |                   |                         |
drawUpHalfRectangle():-
    put_char('|'),tab(5),put_char('|'),
    tab(19),put_char('|'),tab(25),put_char('|'),nl.

%|     |----------------------------------------------
drawUpInnerBorderLine():-
    put_char('|'),tab(5),put_char('|'),
    drawHorizontalLine(46),nl.

%|                        |                    |     |
drawBottomHalfRectangle():-
    put_char('|'),tab(25),put_char('|'),
    tab(19),put_char('|'),tab(5),put_char('|'),nl.

%----------------------------------------------|     |
drawBottomInnerBorderLine():-
    drawHorizontalLine(46),put_char('|'),
    tab(5),put_char('|'),nl.

%    -----------------------------------------------------
% X  |     |                   |                         |
%    |     |                   |                         |
%    |     |----------------------------------------------
drawUpBorder(OldID,NewID):- 
    tab(2),drawHorizontalLine(53),nl,
    tab(1),drawRowID(OldID),NewID = OldID + 1, drawUpHalfRectangle(),
    tab(2),drawUpHalfRectangle(),
    tab(2),drawUpInnerBorderLine().

%    ----------------------------------------------|     |
% X  |                        |                    |     |
%    |                        |                    |     |
%    -----------------------------------------------------
drawBottomBorder(OldID):-  
    tab(2),drawBottomInnerBorderLine(), 
    drawRowID(OldID), drawBottomHalfRectangle(),
    tab(2), drawBottomHalfRectangle(),
    tab(2),drawHorizontalLine(53).

%|     |---------------------------------------|     |
drawRowSeparator():- 
    put_char('|'),tab(5),put_char('|'),
    drawHorizontalLine(39),put_char('|'),tab(5),put_char('|'),nl.

%| S   |   /
drawSquaresUp1():-
    put_char('|'),tab(1),
    ansi_format([bold,fg(cyan)], '~w', [s]),
    tab(2),put_char('|'),
    tab(1),put_char('T'),
    tab(1),put_char('/').

%|    |/ T |
drawSquaresDown1():-
    put_char('|'),tab(4),put_char('|'),
    put_char('/'),tab(1),put_char('T'),tab(1).

%|\ T | S  |
drawSquaresUp2():-
    put_char('|'),put_char('\\'),tab(1),
    put_char('T'),tab(1),put_char('|'),
    tab(1),put_char('S'),tab(2).

%| T \|    |
drawSquaresDown2():-
    put_char('|'),tab(1),put_char('T'),
    tab(1),put_char('\\'),
    put_char('|'),tab(4).

% X  |     |    |   /|    |   /|    |   /|    |   /|     |
%    |     |    |/   |    |/   |    |/   |    |/   |     |
drawInnerRow1(OldID,NewID):-
   (OldID < 10 -> tab(1);tab(0)),drawRowID(OldID), AuxID = OldID + 1, 
   put_char('|'),tab(5),
   drawSquaresUp1(),drawSquaresUp1(),drawSquaresUp1(),drawSquaresUp1(),
   put_char('|'),tab(5),put_char('|'),nl,
   (AuxID < 10 -> tab(2);tab(2)),NewID = AuxID , 
   put_char('|'),tab(5),
   drawSquaresDown1(),drawSquaresDown1(),drawSquaresDown1(),drawSquaresDown1(),
   put_char('|'),tab(5),put_char('|'),nl.

% X  |     |\   |    |\   |    |\   |    |\   |    |     |
% X+1|     |   \|    |   \|    |   \|    |   \|    |     |    
drawInnerRow2(OldID, NewID):-
    (OldID < 10 -> tab(1);tab(0)),drawRowID(OldID), AuxID = OldID + 1,
    put_char('|'),tab(5),
    drawSquaresUp2(),drawSquaresUp2(),drawSquaresUp2(),drawSquaresUp2(),
    put_char('|'),tab(5),put_char('|'),nl,
    (AuxID < 10 -> tab(2);tab(2)), NewID = AuxID, 
    put_char('|'),tab(5),
    drawSquaresDown2(),drawSquaresDown2(),drawSquaresDown2(),drawSquaresDown2(),
    put_char('|'),tab(5),put_char('|'),nl.

%  3|     |    |   /|    |   /|    |   /|    |   /|     |
%  4|     |    |/   |    |/   |    |/   |    |/   |     |
%   |     |---------------------------------------|     |
%  5|     |\   |    |\   |    |\   |    |\   |    |     |
%  6|     |   \|    |   \|    |   \|    |   \|    |     |
%   |     |---------------------------------------|     |
%  7|     |    |   /|    |   /|    |   /|    |   /|     |
%  8|     |    |/   |    |/   |    |/   |    |/   |     |
%   |     |---------------------------------------|     |
%  9|     |\   |    |\   |    |\   |    |\   |    |     |
% 10|     |   \|    |   \|    |   \|    |   \|    |     |
drawInnerHalf(OldID,NewID):-
    drawInnerRow1(OldID,Aux1), tab(2), drawRowSeparator(),
    drawInnerRow2(Aux1,Aux2), tab(2), drawRowSeparator(),
    drawInnerRow1(Aux2,Aux3), tab(2), drawRowSeparator(),
    drawInnerRow2(Aux3,NewID).

drawColumnIds():-
    writef("  |A    | B  |  C |  D |  E |  F |  G |  H | I  |  J  |"),nl.

drawRowID(ID):- format('~d',ID).

%   |A    | B  |  C |  D |  E |  F |  G |  H | I  |  J  |
%   -----------------------------------------------------
%  1|     |                   |                         |
%   |     |                   |                         |
%   |     |----------------------------------------------
%  2|     |    |   /|    |   /|    |   /|    |   /|     |
%   |     |    |/   |    |/   |    |/   |    |/   |     |
%   |     |---------------------------------------|     |
%  3|     |\   |    |\   |    |\   |    |\   |    |     |
%   |     |   \|    |   \|    |   \|    |   \|    |     |
%   |     |---------------------------------------|     |
%  4|     |    |   /|    |   /|    |   /|    |   /|     |
%   |     |    |/   |    |/   |    |/   |    |/   |     |
%   |     |---------------------------------------|     |
%  5|     |\   |    |\   |    |\   |    |\   |    |     |
%   |     |   \|    |   \|    |   \|    |   \|    |     |
%   -----------------------------------------------------
% 6 |     |    |   /|    |   /|    |   /|    |   /|     |
%   |     |    |/   |    |/   |    |/   |    |/   |     |
%   |     |---------------------------------------|     |
% 7 |     |\   |    |\   |    |\   |    |\   |    |     |
%   |     |   \|    |   \|    |   \|    |   \|    |     |
%   |     |---------------------------------------|     |
% 8 |     |    |   /|    |   /|    |   /|    |   /|     |
%   |     |    |/   |    |/   |    |/   |    |/   |     |
%   |     |---------------------------------------|     |
% 9 |     |\   |    |\   |    |\   |    |\   |    |     |
%   |     |   \|    |   \|    |   \|    |   \|    |     |
%   ----------------------------------------------|     |
% 10|                        |                    |     |
%   |                        |                    |     |
%   -----------------------------------------------------
drawBoard([Row1|Rows1]):- 
    %%drawRow1(Row1),
    %%Rows1 is [Row2|Rows2],
    %%drawRow2(Row2),
    %%Rows2 is [Row3|Rows3],
    %%drawRow3(Row3),
    %%Rows3 is [Row4|Rows4],
    %%drawRow4(Row4),
    %%Rows4 is [Row5|Rows5],
    %%drawRow5(Row5),
    %%Rows5 is [Row6|Rows6],
    %%drawRow6(Row6),
    %%Rows6 is [Row7|Rows7],
    %%drawRow7(Row7),
    %%Rows7 is [Row8|Rows8],
    %%drawRow8(Row8),
    %%Rows8 is [Row9|Rows9],
    %%drawRow9(Row9),
    %%Rows9 is [Row10|Rows10],
    %%drawRow10(Row10),
    OldID = 1,drawColumnIds(),
    drawUpBorder(OldID,Aux1),
    drawInnerHalf(Aux1,Aux2),
    tab(2),drawHorizontalLine(53),nl,
    drawInnerHalf(Aux2,Aux3),
    drawBottomBorder(Aux3).

buildList(L) :-
    makelist( [
        [ [[1,A],[0,1]], [[1,B],[0,2]], [[1,C],[0,2]], [[1,D],[0,2]], [[1,E],[0,2]], [[1,F],[0,1]], [[1,G],[0,1]], [[1,H],[0,1]], [[1,I],[0,1]], [[1,J],[0,1]] ], 
        [ [[2,A],[0,1]], [[2,B],[0,0]], [[2,C],[[0,5],[0,6]]], [[2,D],[0,0]], [[2,E],[[0,5],[0,6]]], [[2,F],[0,0]], [[2,G],[[0,5],[0,6]]], [[2,H],[0,0]], [[2,I],[[0,5],[0,6]]], [[2,J],[0,2]] ],
        [ [[3,A],[0,1]], [[3,B],[[0,3],[0,4]]], [[3,C],[0,0]], [[3,D],[[0,3],[0,4]]], [[3,E],[0,0]], [[3,F],[[0,3],[0,4]]], [[3,G],[0,0]], [[3,H],[[0,3],[0,4]]], [[3,I],[0,0]], [[3,J],[[0,2]] ],
        [ [[4,A],[0,1]], [[4,B],[0,0]], [[4,C],[[0,5],[0,6]]], [[4,D],[0,0]], [[4,E],[[0,5],[0,6]]], [[4,F],[0,0]], [[4,G],[[0,5],[0,6]]], [[4,H],[0,0]], [[4,I],[[0,5],[0,6]]], [[4,J],[0,2]] ],        
        [ [[5,A],[0,1]], [[5,B],[[0,3],[0,4]]], [[5,C],[0,0]], [[5,D],[[0,3],[0,4]]], [[5,E],[0,0]], [[5,F],[[0,3],[0,4]]], [[5,G],[0,0]], [[5,H],[[0,3],[0,4]]], [[5,I],[0,0]], [[5,J],[[0,2]] ],      
        [ [[6,A],[0,2]], [[6,B],[0,0]], [[6,C],[[0,5],[0,6]]], [[6,D],[0,0]], [[6,E],[[0,5],[0,6]]], [[6,F],[0,0]], [[6,G],[[0,5],[0,6]]], [[6,H],[0,0]], [[6,I],[[0,5],[0,6]]], [[6,J],[0,2]] ],
        [ [[7,A],[0,2]], [[7,B],[[0,3],[0,4]]], [[7,C],[0,0]], [[7,D],[[0,3],[0,4]]], [[7,E],[0,0]], [[7,F],[[0,3],[0,4]]], [[7,G],[0,0]], [[7,H],[[0,3],[0,4]]], [[7,I],[0,0]], [[7,J],[[0,2]] ], 
        [ [[8,A],[0,2]], [[8,B],[0,0]], [[8,C],[[0,5],[0,6]]], [[8,D],[0,0]], [[8,E],[[0,5],[0,6]]], [[8,F],[0,0]], [[8,G],[[0,5],[0,6]]], [[8,H],[0,0]], [[8,I],[[0,5],[0,6]]], [[8,J],[0,2]] ],
        [ [[9,A],[0,2]], [[9,B],[[0,3],[0,4]]], [[9,C],[0,0]], [[9,D],[[0,3],[0,4]]], [[9,E],[0,0]], [[9,F],[[0,3],[0,4]]], [[9,G],[0,0]], [[9,H],[[0,3],[0,4]]], [[9,I],[0,0]], [[9,J],[[0,2]] ],
        [ [[10,A],[0,1]], [[10,B],[0,1]], [[10,C],[0,1]], [[10,D],[0,1]], [[10,E],[0,1]], [[10,F],[0,2]], [[10,G],[0,2]], [[10,H],[0,2]], [[10,I],[0,2]], [[10,J],[0,1]] ],
    ].