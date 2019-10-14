



% %    -----------------------------------------------------
% % X  |     |                   |                         |
% %    |     |                   |                         |
% %    |     |----------------------------------------------
% drawUpBorder(OldID,NewID):- 
%     tab(2),drawHorizontalLine(53),nl,
%     tab(1),drawRowID(OldID),NewID = OldID + 1, drawUpHalfRectangle(),
%     tab(2),drawUpHalfRectangle(),
%     tab(2),drawUpInnerBorderLine().

% %    ----------------------------------------------|     |
% % X  |                        |                    |     |
% %    |                        |                    |     |
% %    -----------------------------------------------------
% drawBottomBorder(OldID):-  
%     tab(2),drawBottomInnerBorderLine(), 
%     drawRowID(OldID), drawBottomHalfRectangle(),
%     tab(2), drawBottomHalfRectangle(),
%     tab(2),drawHorizontalLine(53).


% %| S   |   
% drawSquaresUp():-
%     put_char('|'),tab(1),ansi_format([bold,fg(cyan)], '~w', [s]),tab(2),put_char('|').

% %  T /
% drawTriangUp1():-
%     tab(1),put_char('T'), tab(1),put_char('/').


% %/ T |
% drawTriangDown1():-
%     put_char('/'),tab(1),put_char('T'),tab(1).

% %|\ T 
% drawTriangUp2():-
%     put_char('\\'),tab(1),
%     put_char('T'),tab(1).


% %| T \
% drawTriangDown2():-
%     tab(1),put_char('T'),
%     tab(1),put_char('\\').


% % X  |     |    |   /|    |   /|    |   /|    |   /|     |
% %    |     |    |/   |    |/   |    |/   |    |/   |     |
% drawInnerRow1(OldID,NewID):-
%    (OldID < 10 -> tab(1);tab(0)),drawRowID(OldID), AuxID = OldID + 1, 
%    put_char('|'),tab(5),
%    drawSquaresUp(),drawTriangUp1(),drawSquaresUp(),drawTriangUp1(), drawSquaresUp(),drawTriangUp1(), drawSquaresUp(),drawTriangUp1(), 
%    put_char('|'),tab(5),put_char('|'),nl,
%    (AuxID < 10 -> tab(2);tab(2)),NewID = AuxID , 
%    put_char('|'),tab(5),
%    drawSquaresDown(),drawTriangDown1(), drawSquaresDown(),drawTriangDown1(),drawSquaresDown(),drawTriangDown1(),drawSquaresDown(),drawTriangDown1(),
%    put_char('|'),tab(5),put_char('|'),nl.

% % X  |     |\   |    |\   |    |\   |    |\   |    |     |
% % X+1|     |   \|    |   \|    |   \|    |   \|    |     |    
% drawInnerRow2(OldID, NewID):-
%     (OldID < 10 -> tab(1);tab(0)),drawRowID(OldID), AuxID = OldID + 1,
%     put_char('|'),tab(5),
%     drawTriangUp2(),drawSquaresUp(),drawTriangUp2(),drawSquaresUp(),drawTriangUp2(), drawSquaresUp(),drawTriangUp2(),drawSquaresUp(),
%     put_char('|'),tab(5),put_char('|'),nl,
%     (AuxID < 10 -> tab(2);tab(2)), NewID = AuxID, 
%     put_char('|'),tab(5),
%     drawTriangDown2(),drawSquaresDown(),drawTriangDown2(),drawSquaresDown(),drawTriangDown2(),drawSquaresDown(),drawTriangDown2(),drawSquaresDown(),
%     put_char('|'),tab(5),put_char('|'),nl.

% %  3|     |    |   /|    |   /|    |   /|    |   /|     |
% %  4|     |    |/   |    |/   |    |/   |    |/   |     |
% %   |     |---------------------------------------|     |
% %  5|     |\   |    |\   |    |\   |    |\   |    |     |
% %  6|     |   \|    |   \|    |   \|    |   \|    |     |
% %   |     |---------------------------------------|     |
% %  7|     |    |   /|    |   /|    |   /|    |   /|     |
% %  8|     |    |/   |    |/   |    |/   |    |/   |     |
% %   |     |---------------------------------------|     |
% %  9|     |\   |    |\   |    |\   |    |\   |    |     |
% % 10|     |   \|    |   \|    |   \|    |   \|    |     |
% drawInnerHalf(OldID,NewID):-
%     drawInnerRow1(OldID,Aux1), tab(2), drawRowSeparator(),
%     drawInnerRow2(Aux1,Aux2), tab(2), drawRowSeparator(),
%     drawInnerRow1(Aux2,Aux3), tab(2), drawRowSeparator(),
%     drawInnerRow2(Aux3,NewID).

%/////////////////////////////////// CURRENT VERSION //////////////////////////////////
%//////////////////////////////////////////////////////////////////////////////////////

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% DEBUGGING %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

print(Term) :-
    current_prolog_flag(print_write_options, Options), !,
    write_term(Term, Options).
print(Term) :-
    write_term(Term, [ portray(true),
                       numbervars(true),
                       quoted(true)
                     ]).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% HELPER FUNCTIONS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Color codes
color(magenta,1).
color(white,0).
color(cyan,2).

drawColumnIds():-
    writef("  | A  | B  | C  | D  | E  | F  | G  | H  | I  | J  |"),nl.

drawRowID(ID):- format('~d',ID).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% BOARD BUILDING %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%----------------------
drawHorizontalLine(0).
drawHorizontalLine(X):-
    X1 is X-1,put_char('-'),drawHorizontalLine(X1).

%----------------------------------------------|     |
drawBottomInnerBorderLine():-
    tab(2),drawHorizontalLine(45),put_char('|'),
    tab(4),put_char('|'),nl.
%|     |----------------------------------------------
drawUpInnerBorderLine():-
    tab(2),put_char('|'),tab(4),put_char('|'),
    drawHorizontalLine(45),nl.
    
%|     |---------------------------------------|     |
drawRowSeparator():- 
    tab(2),put_char('|'),tab(4),put_char('|'),
    drawHorizontalLine(39),put_char('|'),tab(4),put_char('|'),nl.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% SQUARES %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%|  S  | 
drawSqrUp(L):-
    [_|T1] = L,
    [Tail|[]] = T1,
    [T2|_] = Tail,
    color(C,T2),
    put_char('|'),tab(1),ansi_format([bold,fg(C)], '~w', ['S']),tab(2),put_char('|').

%|     |
drawSqrDwn():-            
    put_char('|'),tab(4),put_char('|').

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% RECTANGLES %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%|  R  |
drawRetPrtUp(L):-
    [_|T1] = L,
    [Tail|[]] = T1,
    [T2|_] = Tail,
    color(C,T2),
    put_char('|'),tab(1),ansi_format([bold,fg(C)], '~w', ['R']),tab(2),put_char('|').

%   R   
drawRetPrtMid(L):-
    [_|T1] = L,
    [Tail|[]] = T1,
    [T2|_] = Tail,
    color(C,T2),
    tab(2),ansi_format([bold,fg(C)], '~w', ['R']),tab(2).

%|  R
drawRetPrtLft(L):-
    [_|T1] = L,
    [Tail|[]] = T1,
    [T2|_] = Tail,
    color(C,T2),
    put_char('|'),tab(1),ansi_format([bold,fg(C)], '~w', ['R']),tab(2).

%   R  |
drawRetPrtRgt(L):-
    [_|T1] = L,
    [Tail|[]] = T1,
    [T2|_] = Tail,
    color(C,T2),
    tab(1),ansi_format([bold,fg(C)], '~w', ['R']),tab(2),put_char('|').

%|    
drawRetPrtDwn1():-            
    put_char('|'),tab(4).

%    |      
drawRetPrtDwn2():-            
    tab(4),put_char('|'). 

% %|     |                   |                         |
drawUpHalfRectangle():-
    tab(2),put_char('|'),tab(4),put_char('|'),
    tab(19),put_char('|'),tab(24),put_char('|'),nl.

%|                        |                    |     |
drawBottomHalfRectangle():-
    tab(2),put_char('|'),tab(24),put_char('|'),
    tab(19),put_char('|'),tab(4),put_char('|'),nl.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TRIANGLES %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

getUpTriColor(L,Color):-
    [_|T1] = L,
    [Tail|[]] = T1,
    [T2|_] = Tail,
    [T3|_] = T2,
    color(Color,T3).

%  T /
drawTriUp1(L):-
    getUpTriColor(L,Color),
    tab(1),ansi_format([bold,fg(Color)], '~w', ['T']), tab(1),put_char('/').

%|\ T 
drawTriUp2(L):-
    getUpTriColor(L,Color),
    put_char('\\'),tab(1),ansi_format([bold,fg(Color)], '~w', ['T']),tab(1).


getDwnTriColor(L, Color):-
    [_|T1] = L,
    [Tail|[]] = T1,
    [_|T2] = Tail,
    [T3|[]] = T2,
    [T4|_] = T3,
    color(Color,T4).

% T \
drawTriDwn2(L):-
    getDwnTriColor(L,Color),
    tab(1),ansi_format([bold,fg(Color)], '~w', ['T']),tab(1),put_char('\\').

%/ T |
drawTriDwn1(L):-
    getDwnTriColor(L,Color),
    put_char('/'),tab(1),ansi_format([bold,fg(Color)], '~w', ['T']), tab(1).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% BOARD ROW DRAW %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% %    ---------------------------------------------------
% %    |    |                   |                        |
% %   1| R  | R    R    R    R  | R    R    R    R    R  |
% %    |    |---------------------------------------------
drawRow1([C1,C2,C3,C4,C5,C6,C7,C8,C9,C10|_]):-
    tab(2),drawHorizontalLine(51),nl,
    drawUpHalfRectangle(),
    tab(1),drawRowID(1),
    drawRetPrtLft(C1),drawRetPrtLft(C2),
    drawRetPrtMid(C3),drawRetPrtMid(C4),
    drawRetPrtMid(C5),drawRetPrtLft(C6),
    drawRetPrtMid(C7),drawRetPrtMid(C8),
    drawRetPrtMid(C9),tab(1),drawRetPrtRgt(C10),nl,
    drawUpInnerBorderLine().

% %   | R  | S  | T /| S  | T /| S  | T /| S  | T /| S  |
% %   |    |    |/ T |    |/ T |    |/ T |    |/ T |    |
drawRowType1([C1,C2,C3,C4,C5,C6,C7,C8,C9,C10|_]) :-
    drawRetPrtLft(C1),drawSqrUp(C2),
    drawTriUp1(C3),drawSqrUp(C4),
    drawTriUp1(C5),drawSqrUp(C6),
    drawTriUp1(C7),drawSqrUp(C8),
    drawTriUp1(C9),drawRetPrtUp(C10),
    nl,tab(2),drawRetPrtDwn1(),
    drawSqrDwn(), drawTriDwn1(C3),
    drawSqrDwn(), drawTriDwn1(C5),
    drawSqrDwn(), drawTriDwn1(C7),
    drawSqrDwn(), drawTriDwn1(C9),
    drawSqrDwn(),nl.


% %   | R  |\ T | S  |\ T | S  |\ T | S  |\ T | S  | R  |
% %   |    | T \|    | T \|    | T \|    | T \|    |    |
drawRowType2([C1,C2,C3,C4,C5,C6,C7,C8,C9,C10|_]) :-
    drawRetPrtUp(C1), drawTriUp2(C2),
    drawSqrUp(C3), drawTriUp2(C4),
    drawSqrUp(C5), drawTriUp2(C6),
    drawSqrUp(C7), drawTriUp2(C8),
    drawSqrUp(C9), drawRetPrtRgt(C10),
    nl,tab(2),drawSqrDwn(),
    drawTriDwn2(C2),drawSqrDwn(), 
    drawTriDwn2(C4),drawSqrDwn(), 
    drawTriDwn2(C6),drawSqrDwn(), 
    drawTriDwn2(C8),drawSqrDwn(), 
    drawRetPrtDwn2(),nl.

% %    ---------------------------------------------|    |
% %    |                        |                   |    |
% %    |                        |                   |    |
% %    ---------------------------------------------------
drawRow10([C1,C2,C3,C4,C5,C6,C7,C8,C9,C10|_]):-
    drawBottomInnerBorderLine(), drawRowID(10),
    drawRetPrtLft(C1), drawRetPrtMid(C2), 
    drawRetPrtMid(C3), drawRetPrtMid(C4), 
    drawRetPrtMid(C5), drawRetPrtLft(C6), 
    drawRetPrtMid(C7), drawRetPrtMid(C8),
    drawRetPrtMid(C9), drawRetPrtUp(C10),nl,
    drawBottomHalfRectangle(),
    tab(2),drawHorizontalLine(51),nl.



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% BOARD DRAW %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

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

drawInitBoard():-
    buildList([R1,R2,R3,R4,R5,R6,R7,R8,R9,R10|_]),
    drawColumnIds(),
    drawRow1(R1),
    tab(1), drawRowID(2), drawRowType1(R2), drawRowSeparator(),
    tab(1), drawRowID(3), drawRowType2(R3), drawRowSeparator(),
    tab(1), drawRowID(4), drawRowType1(R4), drawRowSeparator(),
    tab(1), drawRowID(5), drawRowType2(R5),
    tab(2), drawHorizontalLine(51),nl,
    tab(1), drawRowID(6), drawRowType1(R6), drawRowSeparator(),
    tab(1), drawRowID(7), drawRowType2(R7), drawRowSeparator(),
    tab(1), drawRowID(8), drawRowType1(R8), drawRowSeparator(),
    tab(1), drawRowID(9), drawRowType2(R9),
    drawRow10(R10), nl.
    
    %% PREVIOUS VERSION (TESTING)
    % drawSqrUpp([[1,'A'],[1,1]]),
    % drawTriUpp1([[6,'C'],[[1,5],[2,6]]]),
    % drawTriDwn1([[6,'C'],[[1,5],[2,6]]]),
    % drawTriUpp2([[6,'C'],[[1,3],[2,4]]]),
    % drawTriDwn2([[6,'C'],[[1,3],[2,4]]]).
    
    %% OLD VERSION
    % drawUpBorder(OldID,Aux1),
    % drawInnerHalf(Aux1,Aux2),
    % tab(2),drawHorizontalLine(53),nl,
    % drawInnerHalf(Aux2,Aux3),
    % drawBottomBorder(Aux3).

buildList(L) :-
    append( [
        [ [[1,'A'],[1,1]], [[1,'B'],[0,2]], [[1,'C'],[0,2]], [[1,'D'],[0,2]], [[1,'E'],[0,2]], [[1,'F'],[0,1]], [[1,'G'],[0,1]], [[1,'H'],[0,1]], [[1,'I'],[0,1]], [[1,'J'],[0,1]] ], 
        [ [[2,'A'],[1,1]], [[2,'B'],[2,0]], [[2,'C'],[[0,5],[2,6]]], [[2,'D'],[0,0]], [[2,'E'],[[0,5],[0,6]]], [[2,'F'],[0,0]], [[2,'G'],[[0,5],[0,6]]], [[2,'H'],[0,0]], [[2,'I'],[[0,5],[0,6]]], [[2,'J'],[0,2]] ],
        [ [[3,'A'],[1,1]], [[3,'B'],[[1,3],[1,4]]], [[3,'C'],[1,0]], [[3,'D'],[[2,3],[1,4]]], [[3,'E'],[2,0]], [[3,'F'],[[0,3],[0,4]]], [[3,'G'],[0,0]], [[3,'H'],[[0,3],[0,4]]], [[3,'I'],[0,0]], [[3,'J'],[0,2]] ],
        [ [[4,'A'],[1,1]], [[4,'B'],[2,0]], [[4,'C'],[[2,5],[0,6]]], [[4,'D'],[2,0]], [[4,'E'],[[0,5],[0,6]]], [[4,'F'],[0,0]], [[4,'G'],[[0,5],[0,6]]], [[4,'H'],[0,0]], [[4,'I'],[[0,5],[0,6]]], [[4,'J'],[0,2]] ],        
        [ [[5,'A'],[1,1]], [[5,'B'],[[0,3],[0,4]]], [[5,'C'],[0,0]], [[5,'D'],[[0,3],[0,4]]], [[5,'E'],[0,0]], [[5,'F'],[[0,3],[0,4]]], [[5,'G'],[0,0]], [[5,'H'],[[0,3],[0,4]]], [[5,'I'],[0,0]], [[5,'J'],[0,2]] ],      
        [ [[6,'A'],[1,2]], [[6,'B'],[0,0]], [[6,'C'],[[0,5],[0,6]]], [[6,'D'],[0,0]], [[6,'E'],[[0,5],[0,6]]], [[6,'F'],[0,0]], [[6,'G'],[[0,5],[0,6]]], [[6,'H'],[0,0]], [[6,'I'],[[0,5],[0,6]]], [[6,'J'],[0,2]] ],
        [ [[7,'A'],[1,2]], [[7,'B'],[[0,3],[0,4]]], [[7,'C'],[0,0]], [[7,'D'],[[0,3],[0,4]]], [[7,'E'],[0,0]], [[7,'F'],[[0,3],[0,4]]], [[7,'G'],[0,0]], [[7,'H'],[[0,3],[0,4]]], [[7,'I'],[0,0]], [[7,'J'],[0,2]] ], 
        [ [[8,'A'],[1,2]], [[8,'B'],[0,0]], [[8,'C'],[[0,5],[0,6]]], [[8,'D'],[0,0]], [[8,'E'],[[0,5],[0,6]]], [[8,'F'],[0,0]], [[8,'G'],[[0,5],[0,6]]], [[8,'H'],[0,0]], [[8,'I'],[[0,5],[0,6]]], [[8,'J'],[0,2]] ],
        [ [[9,'A'],[1,2]], [[9,'B'],[[0,3],[0,4]]], [[9,'C'],[0,0]], [[9,'D'],[[0,3],[0,4]]], [[9,'E'],[0,0]], [[9,'F'],[[0,3],[0,4]]], [[9,'G'],[0,0]], [[9,'H'],[[0,3],[0,4]]], [[9,'I'],[0,0]], [[9,'J'],[0,2]] ],
        [ [[10,'A'],[1,1]], [[10,'B'],[1,1]], [[10,'C'],[1,1]], [[10,'D'],[1,1]], [[10,'E'],[1,1]], [[10,'F'],[0,2]], [[10,'G'],[0,2]], [[10,'H'],[0,2]], [[10,'I'],[0,2]], [[10,'J'],[0,1]] ]
    ],[],L).

buildBlankList(L) :-
    append( [
        [ [[1,'A'],[0,1]], [[1,'B'],[0,2]], [[1,'C'],[0,2]], [[1,'D'],[0,2]], [[1,'E'],[0,2]], [[1,'F'],[0,1]], [[1,'G'],[0,1]], [[1,'H'],[0,1]], [[1,'I'],[0,1]], [[1,'J'],[0,1]] ], 
        [ [[2,'A'],[0,1]], [[2,'B'],[0,0]], [[2,'C'],[[0,5],[0,6]]], [[2,'D'],[0,0]], [[2,'E'],[[0,5],[0,6]]], [[2,'F'],[0,0]], [[2,'G'],[[0,5],[0,6]]], [[2,'H'],[0,0]], [[2,'I'],[[0,5],[0,6]]], [[2,'J'],[0,2]] ],
        [ [[3,'A'],[0,1]], [[3,'B'],[[0,3],[0,4]]], [[3,'C'],[0,0]], [[3,'D'],[[0,3],[0,4]]], [[3,'E'],[0,0]], [[3,'F'],[[0,3],[0,4]]], [[3,'G'],[0,0]], [[3,'H'],[[0,3],[0,4]]], [[3,'I'],[0,0]], [[3,'J'],[0,2]] ],
        [ [[4,'A'],[0,1]], [[4,'B'],[0,0]], [[4,'C'],[[0,5],[0,6]]], [[4,'D'],[0,0]], [[4,'E'],[[0,5],[0,6]]], [[4,'F'],[0,0]], [[4,'G'],[[0,5],[0,6]]], [[4,'H'],[0,0]], [[4,'I'],[[0,5],[0,6]]], [[4,'J'],[0,2]] ],        
        [ [[5,'A'],[0,1]], [[5,'B'],[[0,3],[0,4]]], [[5,'C'],[0,0]], [[5,'D'],[[0,3],[0,4]]], [[5,'E'],[0,0]], [[5,'F'],[[0,3],[0,4]]], [[5,'G'],[0,0]], [[5,'H'],[[0,3],[0,4]]], [[5,'I'],[0,0]], [[5,'J'],[0,2]] ],      
        [ [[6,'A'],[0,2]], [[6,'B'],[0,0]], [[6,'C'],[[0,5],[0,6]]], [[6,'D'],[0,0]], [[6,'E'],[[0,5],[0,6]]], [[6,'F'],[0,0]], [[6,'G'],[[0,5],[0,6]]], [[6,'H'],[0,0]], [[6,'I'],[[0,5],[0,6]]], [[6,'J'],[0,2]] ],
        [ [[7,'A'],[0,2]], [[7,'B'],[[0,3],[0,4]]], [[7,'C'],[0,0]], [[7,'D'],[[0,3],[0,4]]], [[7,'E'],[0,0]], [[7,'F'],[[0,3],[0,4]]], [[7,'G'],[0,0]], [[7,'H'],[[0,3],[0,4]]], [[7,'I'],[0,0]], [[7,'J'],[0,2]] ], 
        [ [[8,'A'],[0,2]], [[8,'B'],[0,0]], [[8,'C'],[[0,5],[0,6]]], [[8,'D'],[0,0]], [[8,'E'],[[0,5],[0,6]]], [[8,'F'],[0,0]], [[8,'G'],[[0,5],[0,6]]], [[8,'H'],[0,0]], [[8,'I'],[[0,5],[0,6]]], [[8,'J'],[0,2]] ],
        [ [[9,'A'],[0,2]], [[9,'B'],[[0,3],[0,4]]], [[9,'C'],[0,0]], [[9,'D'],[[0,3],[0,4]]], [[9,'E'],[0,0]], [[9,'F'],[[0,3],[0,4]]], [[9,'G'],[0,0]], [[9,'H'],[[0,3],[0,4]]], [[9,'I'],[0,0]], [[9,'J'],[0,2]] ],
        [ [[10,'A'],[0,1]], [[10,'B'],[0,1]], [[10,'C'],[0,1]], [[10,'D'],[0,1]], [[10,'E'],[0,1]], [[10,'F'],[0,2]], [[10,'G'],[0,2]], [[10,'H'],[0,2]], [[10,'I'],[0,2]], [[10,'J'],[0,1]] ]
    ],[],L).