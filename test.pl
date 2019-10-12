%----------------------
drawHorizontalLine(0).
drawHorizontalLine(X):-
    X1 is X-1,put_char('-'),drawHorizontalLine(X1).

%|     |                   |                         |
drawUpHalfRectangle():-
    put_char('|'),tab(5),put_char('|'),tab(19),put_char('|'),tab(25),put_char('|'),nl.

%|     |----------------------------------------------
drawUpInnerBorderLine():-
    put_char('|'),tab(5),put_char('|'),drawHorizontalLine(46),nl.

%|                        |                    |     |
drawBottomHalfRectangle():-
    put_char('|'),tab(25),put_char('|'),tab(19),put_char('|'),tab(5),put_char('|'),nl.

%----------------------------------------------|     |
drawBottomInnerBorderLine():-
    drawHorizontalLine(46),put_char('|'),tab(5),put_char('|'),nl.

%    -----------------------------------------------------
% X  |     |                   |                         |
% X+1|     |                   |                         |
%    |     |----------------------------------------------
drawUpBorder(OldID,NewID):- 
    tab(2),drawHorizontalLine(53),nl,
    tab(1),drawRowID(OldID),AuxID = OldID + 1, drawUpHalfRectangle(),
    tab(1),drawRowID(AuxID),NewID = AuxID + 1, drawUpHalfRectangle(),
    tab(2),drawUpInnerBorderLine().

%    ----------------------------------------------|     |
% X  |                        |                    |     |
% X+1|                        |                    |     |
%    -----------------------------------------------------
drawBottomBorder(OldID):-  
    tab(2),drawBottomInnerBorderLine(), 
    drawRowID(OldID),AuxID = OldID + 1, drawBottomHalfRectangle(),
    drawRowID(AuxID), drawBottomHalfRectangle(),
    tab(2),drawHorizontalLine(53).

%|     |---------------------------------------|     |
drawRowSeparator():- put_char('|'),tab(5),put_char('|'),drawHorizontalLine(39),put_char('|'),tab(5),put_char('|'),nl.

%|    |   /
drawSquaresUp1():-
    put_char('|'),tab(4),put_char('|'),tab(3),put_char('/').

%|    |/   |
drawSquaresDown1():-
    put_char('|'),tab(4),put_char('|'),put_char('/'),tab(3).

%|\   |    |
drawSquaresUp2():-
    put_char('|'),put_char('\\'),tab(3),put_char('|'),tab(4).

%|   \|    |
drawSquaresDown2():-
    put_char('|'),tab(3),put_char('\\'),put_char('|'),tab(4).

% X  |     |    |   /|    |   /|    |   /|    |   /|     |
% X+1|     |    |/   |    |/   |    |/   |    |/   |     |
drawInnerRow1(OldID,NewID):-
    (OldID < 10 -> tab(1);tab(0)),drawRowID(OldID), AuxID = OldID + 1, put_char('|'),tab(5),drawSquaresUp1(),drawSquaresUp1(),drawSquaresUp1(),drawSquaresUp1(),put_char('|'),tab(5),put_char('|'),nl,
    (AuxID < 10 -> tab(1);tab(0)),drawRowID(AuxID), NewID = AuxID + 1, put_char('|'),tab(5),drawSquaresDown1(),drawSquaresDown1(),drawSquaresDown1(),drawSquaresDown1(),put_char('|'),tab(5),put_char('|'),nl.

% X  |     |\   |    |\   |    |\   |    |\   |    |     |
% X+1|     |   \|    |   \|    |   \|    |   \|    |     |    
drawInnerRow2(OldID, NewID):-
    (OldID < 10 -> tab(1);tab(0)),drawRowID(OldID), AuxID = OldID + 1, put_char('|'),tab(5),drawSquaresUp2(),drawSquaresUp2(),drawSquaresUp2(),drawSquaresUp2(),put_char('|'),tab(5),put_char('|'),nl,
    (AuxID < 10 -> tab(1);tab(0)),drawRowID(AuxID), NewID = AuxID + 1, put_char('|'),tab(5),drawSquaresDown2(),drawSquaresDown2(),drawSquaresDown2(),drawSquaresDown2(),put_char('|'),tab(5),put_char('|'),nl.

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
    writef("  |A   B|C  D|E  F|G  H|I  J|K  L|M  N|O  P|Q  R|S   T|"),nl.

drawRowID(ID):- format('~d',ID).
%    A  B  C  D E  F G  H I  J K  L M  N O  P Q  R S   T 
%   -----------------------------------------------------
%  1|     |                   |                         |
%  2|     |                   |                         |
%   |     |----------------------------------------------
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
%   -----------------------------------------------------
% 11|     |    |   /|    |   /|    |   /|    |   /|     |
% 12|     |    |/   |    |/   |    |/   |    |/   |     |
%   |     |---------------------------------------|     |
% 13|     |\   |    |\   |    |\   |    |\   |    |     |
% 14|     |   \|    |   \|    |   \|    |   \|    |     |
%   |     |---------------------------------------|     |
% 15|     |    |   /|    |   /|    |   /|    |   /|     |
% 16|     |    |/   |    |/   |    |/   |    |/   |     |
%   |     |---------------------------------------|     |
% 17|     |\   |    |\   |    |\   |    |\   |    |     |
% 18|     |   \|    |   \|    |   \|    |   \|    |     |
%   ----------------------------------------------|     |
% 19|                        |                    |     |
% 20|                        |                    |     |
%   -----------------------------------------------------
drawBoard():-OldID = 1,drawColumnIds(),
    drawUpBorder(OldID,Aux1),
    drawInnerHalf(Aux1,Aux2),
    tab(2),drawHorizontalLine(53),nl,
    drawInnerHalf(Aux2,Aux3),
    drawBottomBorder(Aux3).

/*
Pieces to refer:
    - small rectangle up [1-2][C-J]
    - small rectangle left [11-18][A-B]
    - small rectangle right [3-10][S-T]
    - small recatngle down [19-20][K-R]
    - big rectangle up [1-2][K-T]
    - big rectangle left [1-10][A-B]
    - big rectangle right [11-20][S-T]
    - big recatngle down [19-20][A-J]
    - squares:
        + [3-4]; [7-8]; [11-12] [15-16]:
            º [C-D]
            º [G-H]
            º [K-L]
            º [O-P]
        + [5-6]; [9-10]; [13-14]; [17-18]:
            º [E-F]
            º [I-J]
            º [M-N]
            º [Q-R]
    - triangles:
        + ◸:
            º[3];[7];[11];[15]:
                * [E]
                * [I]
                * [M]
                * [Q]
        + ◿:
            º[4];[8];[12];[16]:
                * [F]
                * [J]
                * [N]
                * [R]
        + ◹:
            º[5];[9];[13];[17]:
                * [D]
                * [H]
                * [L]
                * [P]
        + ◺:
            º[6];[10];[14];[18]:
                * [C]
                * [G]
                * [K]
                * [O]
*/
