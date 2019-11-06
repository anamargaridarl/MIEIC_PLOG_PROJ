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
color(green,2).

isTriangle(AuxT,T):-
    AuxT == '\n', T is -1;
    AuxT == 'U', T is 0;
    AuxT == 'D', T is 1.

getPlayInfo(X,Y,T):-
    writef("Write coordinates: (xyT)"),nl,
    get_char(AuxX),get_char(AuxY),get_char(AuxT),
    isTriangle(AuxT,T),
    char_code(AuxX,AuxX2), 
    atom_number(AuxY,Y),
    X is AuxX2-64.

playerTurn(Player) :-
    color(C,Player),
    writef("  Player "),
    ansi_format([bold,fg(C)], '~w', [Player]), writef(" turn."),nl.

winMessage(Player) :-
    color(C,Player),
    writef("  Player "),
    ansi_format([bold,fg(C)], '~w', [Player]),writef(" wins!"),nl.

tieMessage() :-
    writef("Its a tie!"),nl.

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

drawSqrUp([C|_]):-
    color(Name,C),
    put_char('|'),tab(1),ansi_format([bold,fg(Name)], '~w', ['■']),tab(1),put_char('|').

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% RECTANGLES %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

drawRetPrtUp([C|_]):-
    color(Name,C),
    put_char('|'),tab(1),ansi_format([bold,fg(Name)], '~w', ['■']),tab(1),put_char('|').

drawRetPrtMid([C|_]):-
    color(Name,C),
    tab(1),ansi_format([bold,fg(Name)], '~w', ['■']),tab(2).

drawRetPrtMid([C1|_],[C2|_]) :-
    color(Name1,C1),
    color(Name2,C2),
    tab(1),ansi_format([bold,fg(Name1)], '~w', ['■']),tab(1),put_char('|'),
    tab(1),ansi_format([bold,fg(Name2)], '~w', ['■']),tab(2).

drawRetPrtLft([C|_]):-
    color(Name,C),
    put_char('|'),tab(1),ansi_format([bold,fg(Name)], '~w', ['■']),tab(1).

drawRetPrtRgt([C|_]):-
    color(Name,C),
    tab(1),ansi_format([bold,fg(Name)], '~w', ['■']),tab(1),put_char('|').

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TRIANGLES %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

getUpTriColor([UpT|_],Color):-
    [C|_] = UpT,
    color(Color,C).

getDwnTriColor([_|DwnT], Color):-
    [[C|_]|_] = DwnT,
    color(Color,C).

drawTri2(L):-
    getUpTriColor(L,Color),
    ansi_format([bold,fg(Color)], '~w', ['◤']),
    getDwnTriColor(L,Color2),
    ansi_format([bold,fg(Color2)], '~w', ['◢']),tab(1).

drawTri1(L) :-
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

display_game([R1,R2,R3,R4,R5,R6,R7,R8,R9,R10|_],Player):-
    playerTurn(Player),
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

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% REPORT VISUALIZATION %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%used for report images
display_blank() :-
    buildBlankList(L),
    display_game(L,2).

display_start() :-
    buildStartList(L),
    display_game(L,1).

display_inter() :-
    buildIntList(L),
    display_game(L,2).

display_final() :-
    buildFinalList(L),
    display_game(L,1),
    winMessage(1).

display_tie() :-
    buildTieList(L),
    display_game(L,2),
    tieMessage().

