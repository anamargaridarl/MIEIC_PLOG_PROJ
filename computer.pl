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
%getGreedyPiece(+BoardIn,+PlayedList,+Player,+PossList,-Row,-Col,-Tri)
%Computer will play each possible piece and select the one that
%gives the opponent the lowest number of possible plays.
%The idea is that the less possible plays, the more restricted the
%opponent is, therefore being a greedy strategy.
getGreedyPiece(BoardIn,PlayedList,Player,PossList,Row,Col,Tri) :-
  setof(N-Piece,(validPlay(Piece,PossList),
                evalPiece(BoardIn,PlayedList,Player,Piece,N),[Play|_])),
  Play = [N-[[Row,Col],[_|ID]]],
  isTri(ID,Tri).
    

evalPiece(BoardIn,PlayedList,Player,[[Row,Col],[_|ID]],N) :-
  isTri(ID,T),
  fillPiece(BoardIn,Row,Col,T,Player,BoardOut),        %fill piece with player color
  addPlayAux(PlayedList,BoardOut,Col,Row,T, Pl2),
  possiblePlays(BoardOut,Pl2,OpponentList),
  length(OpponentList,NumAux),
  N is 0-NumAux.