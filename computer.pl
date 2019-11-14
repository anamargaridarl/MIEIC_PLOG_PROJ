%%%%%%%%%%%%%%%%% Evaluation functions %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
:- use_module(library(random)).



  
%%%%%%% Level 0 AI %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%getRandomPiece(+PossList,-Row,-Col,-Tri)
%Computer will select randomly one of the possible pieces
%it has to play
getRandomPiece(PossList,Row,Col,Tri) :-
  length(PossList,Size),
  random(1, Size, N),
  nth1(N,PossList,[[Row,Col],[_,ID]],_),
  isTri(ID,Tri).

%%%%%% Level 1 AI %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%getGreedyPiece(+TabIn,+Played,+Player,+PossList,-Row,-Col,-Tri)
%Computer will play each possible piece and select the one that
%gives the opponent the lowest number of possible plays.
%The idea is that the less possible plays, the more restricted the
%opponent is, therefore being a greedy strategy.
% getGreedyPiece(TabIn,Played,Player,PossList,Row,Col,Tri) :-
%   setof(N-Piece,(validPlay(Piece,PossList),
%                 evalPiece(TabIn,Played,Player,Piece,N)),[Play|_]),
%   Play = [N-[[Row,Col],[_|ID]]],
%   isTri(ID,Tri).

getGreedyPiece(TabIn,Played,Player,[First|Rest],Row,Col,Tri) :-
  evalPiece(TabIn,Played,Player,First,N),
  getMinValue(TabIn,Played,Player,Rest,N,First,Best),
  Best = [[Row,Col],[_,ID]],
  isTri(ID,Tri).

getMinValue(_,_,_,[],_,Best,Best).
getMinValue(TabIn,Played,Player,[Piece|Rest],N,Aux,Best) :-
  evalPiece(TabIn,Played,Player,Piece,TempN),
  ((TempN @> N, getMinValue(TabIn,Played,Player,Rest,TempN,Piece,Best));
  getMinValue(TabIn,Played,Player,Rest,N,Aux,Best)).

evalPiece(TabIn,Played,Player,[[Row,Col],[_,ID]],N) :-
  makeFakeMove(TabIn,Played,Player,Row,Col,ID,Played2,TabOut),
  valid_moves(TabOut,Played2,ToPlay),
  getOposPlayer(Player,Opponent),
  getPlayerPieces(Played2,Opponent,OppPieces),
  getAllAdjacents(TabOut,OppPieces,Adjacents),
  % list_to_set(Adjacents,AdjSet),
  % list_to_set(ToPlay,ToPlaySet),  
  % intersection(AdjSet,ToPlaySet,PlayerPoss),
  intersection(Adjacents,ToPlay,PlayerPoss),
  length(PlayerPoss,NumAux),
  N is 0-NumAux.

makeFakeMove(TabIn,Played,Player,Row,Col,ID,PlayedOut,TabOut):-
  isTri(ID,T),
  fillPiece(TabIn,Row,Col,T,Player,TabOut),
  addPlayAux(Played,TabOut,Col,Row,T, PlayedOut).

getPlayerPieces([],_,[]).
getPlayerPieces([Elem|Rest],Player,[E2|Rest2]) :-
  Elem = [_,[Fill,_]],
  Fill == Player,
  E2 = Elem, 
  getPlayerPieces(Rest,Player,Rest2).

getPlayerPieces([_|Rest],Player,ListOut) :-
  getPlayerPieces(Rest,Player,ListOut).

getAllAdjacents(TabIn,OppPieces,Adjacents) :-
  getAllAdjacent(TabIn,OppPieces,[],Adjacents).

getAllAdjacent(_,[],Adjacents,Adjacents).
getAllAdjacent(TabIn,[Piece|Rest],Aux,Adjacents) :-
  lookForAdjacent(TabIn,Piece,Adjs),
  append(Adjs,Aux,NewAux),
  getAllAdjacent(TabIn,Rest,NewAux,Adjacents).
