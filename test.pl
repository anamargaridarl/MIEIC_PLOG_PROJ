
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
    writef("  | A | B | C | D | E | F | G | H | I | J |"),nl.

drawRowID(ID):- format('~d',ID).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% BOARD BUILDING %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%----------------------
drawHorizontalLine(0).
drawHorizontalLine(X):-
    X1 is X-1,put_char('-'),drawHorizontalLine(X1).

%----------------------------------------------|     |
drawBottomInnerBorderLine():-
    tab(2),drawHorizontalLine(36),put_char('|'),
    tab(3),put_char('|'),nl.
%|     |----------------------------------------------
drawUpInnerBorderLine():-
    tab(2),put_char('|'),tab(3),put_char('|'),
    drawHorizontalLine(36),nl.
    
%|     |---------------------------------------|     |
drawRowSeparator():- 
    tab(2),put_char('|'),tab(3),put_char('|'),
    drawHorizontalLine(31),put_char('|'),tab(3),put_char('|'),nl.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% SQUARES %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

drawSqrUp(L):-
    [_|T1] = L,
    [Tail|[]] = T1,
    [T2|_] = Tail,
    color(C,T2),
    put_char('|'),tab(1),ansi_format([bold,fg(C)], '~w', ['■']),tab(1),put_char('|').

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% RECTANGLES %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

drawRetPrtUp(L):-
    [_|T1] = L,
    [Tail|[]] = T1,
    [T2|_] = Tail,
    color(C,T2),
    put_char('|'),tab(1),ansi_format([bold,fg(C)], '~w', ['■']),tab(1),put_char('|').

drawRetPrtMid(L):-
    [_|T1] = L,
    [Tail|[]] = T1,
    [T2|_] = Tail,
    color(C,T2),
    tab(1),ansi_format([bold,fg(C)], '~w', ['■']),tab(2).

drawRetPrtMid(L1,L2) :-
    [_|T1] = L1,[Tail|[]] = T1,
    [T2|_] = Tail,color(C,T2),
    [_|T3] = L2,[Tail2|[]] = T3,
    [T4|_] = Tail2,color(C1,T4),
    tab(1),ansi_format([bold,fg(C)], '~w', ['■']),tab(1),put_char('|'),
    tab(1),ansi_format([bold,fg(C1)], '~w', ['■']),tab(2).

drawRetPrtLft(L):-
    [_|T1] = L,
    [Tail|[]] = T1,
    [T2|_] = Tail,
    color(C,T2),
    put_char('|'),tab(1),ansi_format([bold,fg(C)], '~w', ['■']),tab(1).

drawRetPrtRgt(L):-
    [_|T1] = L,
    [Tail|[]] = T1,
    [T2|_] = Tail,
    color(C,T2),
    tab(1),ansi_format([bold,fg(C)], '~w', ['■']),tab(1),put_char('|').

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TRIANGLES %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

getUpTriColor(L,Color):-
    [_|T1] = L,
    [Tail|[]] = T1,
    [T2|_] = Tail,
    [T3|_] = T2,
    color(Color,T3).

getDwnTriColor(L, Color):-
    [_|T1] = L,
    [Tail|[]] = T1,
    [_|T2] = Tail,
    [T3|[]] = T2,
    [T4|_] = T3,
    color(Color,T4).

drawTri1(L):-
    getUpTriColor(L,Color),
    ansi_format([bold,fg(Color)], '~w', ['◤']),
    getDwnTriColor(L,Color2),
    ansi_format([bold,fg(Color2)], '~w', ['◢']),tab(1).

drawTri2(L) :-
    getDwnTriColor(L,Color),
    ansi_format([bold,fg(Color)], '~w', ['◣']),
    getUpTriColor(L,Color2),
    ansi_format([bold,fg(Color2)], '~w', ['◥']),tab(1).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% BOARD ROW DRAW %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

drawRow1([C1,C2,C3,C4,C5,C6,C7,C8,C9,C10|_]):-
    tab(2),drawHorizontalLine(41),nl,
    tab(1),drawRowID(1),
    drawRetPrtUp(C1),drawRetPrtMid(C2),
    drawRetPrtMid(C3),drawRetPrtMid(C4),
    drawRetPrtMid(C5,C6),
    drawRetPrtMid(C7),drawRetPrtMid(C8),
    drawRetPrtMid(C9),drawRetPrtRgt(C10),nl,
    drawUpInnerBorderLine().

drawRowType1([C1,C2,C3,C4,C5,C6,C7,C8,C9,C10|_]) :-
    drawRetPrtLft(C1),drawSqrUp(C2),
    drawTri1(C3),drawSqrUp(C4),
    drawTri1(C5),drawSqrUp(C6),
    drawTri1(C7),drawSqrUp(C8),
    drawTri1(C9),drawRetPrtUp(C10),
    nl.

drawRowType2([C1,C2,C3,C4,C5,C6,C7,C8,C9,C10|_]) :-
    drawRetPrtUp(C1), drawTri2(C2),
    drawSqrUp(C3), drawTri2(C4),
    drawSqrUp(C5), drawTri2(C6),
    drawSqrUp(C7), drawTri2(C8),
    drawSqrUp(C9), drawRetPrtRgt(C10),
    nl.

drawRow10([C1,C2,C3,C4,C5,C6,C7,C8,C9,C10|_]):-
    drawBottomInnerBorderLine(), drawRowID(10),
    drawRetPrtLft(C1), tab(1),drawRetPrtMid(C2), 
    drawRetPrtMid(C3), drawRetPrtMid(C4), 
    drawRetPrtMid(C5,C6),
    drawRetPrtMid(C7), drawRetPrtMid(C8),
    drawRetPrtRgt(C9),drawRetPrtRgt(C10),nl,
    tab(2),drawHorizontalLine(41),nl.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% BOARD DRAW %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

drawInitBoard():-
    buildList([R1,R2,R3,R4,R5,R6,R7,R8,R9,R10|_]),
    drawColumnIds(),
    drawRow1(R1),
    tab(1), drawRowID(2), drawRowType1(R2), drawRowSeparator(),
    tab(1), drawRowID(3), drawRowType2(R3), drawRowSeparator(),
    tab(1), drawRowID(4), drawRowType1(R4), drawRowSeparator(),
    tab(1), drawRowID(5), drawRowType2(R5),
    tab(2), drawHorizontalLine(41),nl,
    tab(1), drawRowID(6), drawRowType1(R6), drawRowSeparator(),
    tab(1), drawRowID(7), drawRowType2(R7), drawRowSeparator(),
    tab(1), drawRowID(8), drawRowType1(R8), drawRowSeparator(),
    tab(1), drawRowID(9), drawRowType2(R9),
    drawRow10(R10), nl.
    
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