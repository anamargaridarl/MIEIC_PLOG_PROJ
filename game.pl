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
    0:getPieceFillOther(TabIn,Row,Col,FillOut),
    1:getPieceFillTriUp(TabIn,Row,Col,FillOut),
    2:getPieceFillTriDwn(TabIn,Row,Col,FillOut)
  ]).



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% GAME LOGIC %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%without handle of triangles
add_play_aux(AuxIn,Board,X,Y,T, AuxOut):-
    atom_number(Y,NY),
    append([[X,NY]], AuxIn, AuxOut).

play(Player, Board, AuxIn, AuxOut):- 
    display_game(Board,Player),
    getPlayInfo(X,Y,T),
    %valid_play(X,Y), (%valid_plays(Aux), valid() )
    %change_board(),
    add_play_aux(AuxIn,Board,X,Y,T, AuxOut).
    %game_state().

plays_loop(Board,Aux):-
    play(1,Board,Aux1,Aux2),
    play(2,Board,Aux2,AuxF),
    print(AuxF),
    plays_loop(Board,AuxF).

game_start():-
    buildBlankList(L),
    plays_loop(L,[]).

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

fillPiece(TabIn,RowN,ColN,Tri,Player,TabOut) :-
  switch(Tri,[
    0:fillPieceOther(TabIn,RowN,ColN,Player,TabOut),
    1:fillPieceTriUp(TabIn,RowN,ColN,Player,TabOut),
    2:fillPieceTriDwn(TabIn,RowN,ColN,Player,TabOut)
  ]).
  
fillOne(X) :-
    buildBlankList(L),
    display_game(L,2),
    fillPieceTriDwn(L,3,2,1,L2),
    getPieceFill(L2,3,3,0,X),
    display_game(L2,1).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Verify Game State %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

 verifyPieceState(TabIn,Player,Piece,Type,Adjs,PieceState).% :-
%   getAdjs(TabIn,Piece,NextTo),
  


%Fill 1 - Player 1;  2 - Player 2
%Type 1 - Rectangle; 2 - Square; 3- Triangle
verifyPieceState(TabIn,Player,[Position,[Fill,Type]|_],PieceState) :-
  (Type is 1 ; \+(Player is Fill)) -> PieceState is 0;
  verifyPieceState(TabIn,Player,[Position,[Fill,Type]],Type,[],PieceState).

verifyPlayerState(_,_,[],0).
verifyPlayerState(TabIn,Player,[Piece|Rest],StateOut) :-
  verifyPieceState(TabIn,Player, Piece, PieceState), %PieceState: 0 - continue 1 - adjacent 2 - surrounded
  verifyPlayerState(TabIn,Player,Rest,StateOut).


% StateOut: 0 - continue; 1- Player 1 wins; 2- Player 2 wins; 3- Tie game
verifyGameState(TabIn,InPlay,StateOut) :-
  verifyPlayerState(TabIn,1,InPlay,P1State), % P1State: 0 - continue 1 - loses
  verifyPlayerState(TabIn,2,InPlay,P2State), % P2State: 0 - continue 1 - loses
  (P1State is 0 -> (P2State is 0 -> StateOut is 0; StateOut is 1 );
  (P1State is 1 -> (P2State is 0 -> StateOut is 2; StateOut is 3))).
