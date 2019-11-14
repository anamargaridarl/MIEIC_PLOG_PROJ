
play_mode(Option) :-
  buildBlankList(L),
  ((Option == 0,twoPlayerGame(L,[]));
  (Option == 1, cpuHumanGame(L,[]));
  (Option == 2, humanCPUGame(L,[]));
  (Option == 3, twoComputerGame(L,[]))).

getOption(Option) :-
  read_line_to_codes(user_input,Codes),
  length(Codes,N), 
  (N == 1; (writef("Invalid option selected"),nl)),
  nth0(0,Codes,Code),
  Option is Code - 48.

play() :-
  writef("Welcome to Boco. Choose game mode: "),nl,
  repeat,
  writef('0 - Human Vs Human'),nl,
  writef('1 - Human Vs Computer'),nl,
  writef('2 - Computer Vs Human'),nl, 
  writef('3 - Computer Vs Computer'),nl,
  getOption(Option),!,
  play_mode(Option).