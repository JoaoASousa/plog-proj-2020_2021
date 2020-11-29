% Checks if both positions to be occupied by a piece fit on the board. If either position fails, informs the user and asks for new input.
% check_move(Board, X1, Y1, X2, Y2):-().

% Determining at random whether the first or second playing entities get to be white
% (0 is Computer, 1 is Player1, 2 is Player2)
% PVP -> Player1 Vs Player2
random_white_number(pvp, White) :-
    random(1, 3, White).
% PVE -> Computer Vs Player1
random_white_number(pve, White) :-
    random(0, 2, White).
% EVE -> Computer Vs Computer
random_white_number(eve, White) :-
    White is 0.

% Chooses random entity to be white color and starts game on selected gamemode (PVP, PVE, EVE)
% selectGamemodeAndStart(+GameState, +Gamemode)
selectGamemodeAndStart(GameState, Gamemode, Level) :-
    % nl, write('Level: '), write(Level), nl, get_char(Input),
    random_white_number(GameMode, WhiteEntity),
    turn(GameState, Gamemode, WhiteEntity, w).

% Switches to next player, depends on game mode
% next_player(+Gamemode, +Player, -NextPlayer)
next_player(pvp, 1, 2).
next_player(pvp, 2, 1).
next_player(pve, 0, 1).
next_player(pve, 1, 0).
next_player(pvp, 0, 0).

% alternate_color(+Color, -NewColor)
alternate_color(w, NewColor) :- NewColor is b.
alternate_color(b, NewColor) :- NewColor is w.

% ----------------------------------------------------------------

game_over(GameState, Winner) :-
    write('Not Full'), nl.

turn(GameState, Gamemode, Player, Color) :-
    clear_terminal,

    % Check if its game over
    % game_over(GameState, Winner),

    % Get and write scores for black and white pieces
    value(GameState, w, WhiteScore), value(GameState, b, BlackScore),
    nl, nl, write('White: '), write(WhiteScore), write(' | Black: '), write(BlackScore), nl, nl, 
    !,

    % Display board and who is playing currently
    display_game(GameState, Player, Color),
    
    % Get input from player to choose position of white piece of Taijitu
    length(GameState, L),
    input_position(InputRow, InputCol, L),
    (
        validate_position(InputRow, InputCol, ValidatedRow, ValidatedCol) -> true;

        nl, write('Invalid Taijitu position!'), nl,                % "Else statement"
        enter_to_continue, nl,
        clear_terminal, turn(GameState, Gamemode, Player, Color)
    ),

    % Get input from player to choose orientation of the taijitu
    input_orientation(Option),
    (
        validate_orientation(Option) -> true;

        nl, write('Invalid Taijitu orientation!'), nl,                % "Else statement"
        enter_to_continue, nl,
        clear_terminal, turn(GameState, Gamemode, Player, Color)
    ),
    
    % Get coords of black piece of Taijitu, according to chosen orientation
    black_move_part(ValidatedRow, ValidatedCol, Option, BlackRow, BlackCol),
    
    Move = [[ValidatedRow, ValidatedCol],[BlackRow, BlackCol]],
    % play_piece(GameState, NewGameState),
    (
        move(GameState, Move, NewGameState) -> success_play(NewGameState, Gamemode, Player, Color, NewPlayer, NewColor);
        
        nl, write('Cant place piece there!'), nl,                % "Else statement"
        enter_to_continue, nl,
        clear_terminal, turn(GameState, Gamemode, Player, Color)
    )
    .
turn(_,_,_,_):- write('Error occured ; leaving').

validate_orientation('1').
validate_orientation('2').
validate_orientation('3').
validate_orientation('4').

% Called if Move is valid, continues to next turn with new GameState
% success_play(+NewGameState, +Gamemode, +Player, +Color, -NewPlayer, -NewColor)
success_play(NewGameState, Gamemode, Player, Color, NewPlayer, NewColor) :-
    nl, write('Success'), nl,
    enter_to_continue,
    next_player(Gamemode, Player, NewPlayer),
    alternate_color(Color, NewColor),
    nl, horizontal_line,
    turn(NewGameState, Gamemode, NewPlayer, NewColor).

% Runs a move's changes on GameState i.e. places white and black pieces of new Taijitu on game board
% move(+GameState, +Move,-NewGameState)
move(GameState, [White|[Black|_]], NewGameState) :- 
  white_piece_move(GameState, White, NewGameState1), 
  black_piece_move(NewGameState1, Black, NewGameState).

white_piece_move(GameState, [Row | [Col|_]], NewGameState1) :-
  replace_(GameState, Row, Col, white, NewGameState1).

black_piece_move(NewGameState1, [Row | [Col|_]], NewGameState) :-
  replace_(NewGameState1, Row, Col, black, NewGameState).

% ----------------------------------------------------------------

% Returns coordinates of black piece of Taijitu, according to chosen orientation
% black_move_part(+Row, +Col, +Option, -BlackRow, -BlackCol)
black_move_part(Row, Col, '1', Row, BlackCol) :- % black on the right
    %write('\nBlack on Right\n'),
    BlackCol is Col + 1.

black_move_part(Row, Col, '2', Row, BlackCol) :- % black on the left
    %write('\nBlack on Left\n'),
    BlackCol is Col - 1.

black_move_part(Row, Col, '3', BlackRow, Col) :- % black on the bottom
    %write('\nBlack on Bottom\n'),
    BlackRow is Row + 1.

black_move_part(Row, Col, '4', BlackRow, Col) :- % black on the top
    %write('\nBlack on Top\n'),
    BlackRow is Row - 1.

% ----------------------------------------------------------------
% Converts row and col chars to their corresponding indexes
convert_input_row('a', 1).
convert_input_row('b', 2).
convert_input_row('c', 3).
convert_input_row('d', 4).
convert_input_row('e', 5).
convert_input_row('f', 6).
convert_input_row('g', 7).
convert_input_row('h', 8).
convert_input_row('i', 9).
convert_input_row('j', 10).
convert_input_row('k', 11).
convert_input_row('A', 1).
convert_input_row('B', 2).
convert_input_row('C', 3).
convert_input_row('D', 4).
convert_input_row('E', 5).
convert_input_row('F', 6).
convert_input_row('G', 7).
convert_input_row('H', 8).
convert_input_row('I', 9).
convert_input_row('J', 10).
convert_input_row('K', 11).

convert_input_col('0', 1).
convert_input_col('1', 2).
convert_input_col('2', 3).
convert_input_col('3', 4).
convert_input_col('4', 5).
convert_input_col('5', 6).
convert_input_col('6', 7).
convert_input_col('7', 8).
convert_input_col('8', 9).
convert_input_col('9', 10).
convert_input_col('X', 11).
% ----------------------------------------------------------------
% Input

% Gets coordinates of white piece of the Taijitu from the user
% input_position(-InputRow, -InputCol, +L)
input_position(InputRow, InputCol, L) :-
    write('White Piece Row ( A - '), LastRowIndex is 64 + L, write_char(LastRowIndex), write('): '), get_char(InputRow), get_char(_), nl,
    write('White Piece Col ( 0 - '), LastColIndex is 47 + L, write_char(LastColIndex), write('): '), get_char(InputCol), get_char(_), nl.

% Checks if inputted row and column are valid values and are inside bounds, returning the values converted to indexes in range [0, 11]
% validate_position(+InputRow, +InputCol, -ConvertedRow, -ConvertedCol)
validate_position(InputRow, InputCol, ConvertedRow, ConvertedCol) :-
    convert_input_row(InputRow, ConvertedRow),
    convert_input_col(InputCol, ConvertedCol),
    ConvertedRow @> 0, ConvertedRow @< 12,
    ConvertedCol @> 0, ConvertedCol @< 12.

% Gets the option of the orientation of the Taijitu from the user
% input_orientation(-Option)
input_orientation(Option) :-
    show_orientations, nl,
    get_char(Option).

% ----------------------------------------------------------------
% Score

% dfs(+GameState, +Color, +ToVisit,+ VisitedIn, +DepthIn, -VisitedOut, -DepthOut)
%% Done, all visited 
dfs(_, _, [], VisitedIn, DepthIn, VisitedOut, DepthOut):-
    (DepthIn \= 1 -> DepthOut is DepthIn ; DepthOut is 0), 
    append([], VisitedIn, VisitedOut),
    !.
%% If has already been visited, skips
dfs(GameState, Color, [H|T], VisitedIn, DepthIn, VisitedOut, DepthOut) :-
    member(H,VisitedIn),
    dfs(GameState, Color, T, VisitedIn, DepthIn, VisitedOut, DepthOut).
%% If isn't correct color, skips and adds to visited
dfs(GameState, Color, [H|T], VisitedIn, DepthIn, VisitedOut, DepthOut) :-
    color(GameState, H, C), 
    C \= Color,
    dfs(GameState, Color, T, [H|VisitedIn], DepthIn, VisitedOut, DepthOut).
%% Add all neigbors of the head to the toVisit
dfs(GameState, Color, [H|T], VisitedIn, DepthIn, VisitedOut, DepthOut) :-
    length(GameState, L),
    findall((X, Y), adjacent((H), (X,Y), L), Nbs),
    addToList(Nbs,T, ToVisit),
    NewDepthIn is DepthIn + 1,
    dfs(GameState, Color, ToVisit, [H|VisitedIn], NewDepthIn, VisitedOut, DepthOut).

% algorithm(+GameState, +Color, +ToVisit, +Accumulator, +VisitedIn, -Value)
algorithm(_, _, [], Accumulator, _, Value):-
    Value is Accumulator.
algorithm(GameState, Color, [H|T], Accumulator, VisitedIn, Value):-
    dfs(GameState, Color, [H], VisitedIn, 0, VisitedOut, X),
    NewAccumulator is Accumulator + X,
    algorithm(GameState, Color, T, NewAccumulator, VisitedOut, Value).

% Returns lists with all indexes of square arrays of length L
% indexes_from_length(+L -Output)
indexes_from_length(L,Output):-
    (L =:= 7 -> append([], [(0,0),(0,1),(0,2),(0,3),(0,4),(0,5),(0,6),(1,0),(1,1),(1,2),(1,3),(1,4),(1,5),(1,6),(2,0),(2, 1),(2,2),(2,3),(2,4),(2,5),(2,6),(3,0),(3,1),(3,2),(3,3),(3,4),(3,5),(3,6),(4,0),(4,1),(4,2),(4,3),(4,4),(4,5),(4,6),(5,0),(5,1),(5,2),(5,3),(5,4),(5,5),(5,6),(6,0),(6,1),(6,2),(6,3),(6,4),(6,5),(6,6)], Output);
    L =:= 9 -> append([], [(0,0),(0,1),(0,2),(0,3),(0,4),(0,5),(0,6),(0,7),(0,8),(1,0),(1,1),(1,2),(1,3),(1,4),(1,5),(1,6),(1,7),(1,8),(2,0),(2,1),(2,2),(2,3),(2,4),(2,5),(2,6),(2,7),(2,8),(3,0),(3,1),(3,2),(3,3),(3,4),(3,5),(3,6),(3,7),(3,8),(4,0),(4,1),(4,2),(4,3),(4,4),(4,5),(4,6),(4,7),(4,8),(5,0),(5,1),(5,2),(5,3),(5,4),(5,5),(5,6),(5,7),(5,8),(6,0),(6,1),(6,2),(6,3),(6,4),(6,5),(6,6),(6,7),(6,8),(7,0),(7,1),(7,2),(7,3),(7,4),(7,5),(7,6),(7,7),(7,8),(8,0),(8,1),(8,2),(8,3),(8,4),(8,5),(8,6),(8,7),(8,8)], Output);
    L =:= 11 -> append([], [(0,0),(0,1),(0,2),(0,3),(0,4),(0,5),(0,6),(0,7),(0,8),(0,9),(0,10),(1,0),(1,1),(1,2),(1,3),(1,4),(1,5),(1,6),(1,7),(1,8),(1,9),(1,10),(2,0),(2,1),(2,2),(2,3),(2,4),(2,5),(2,6),(2,7),(2,8),(2,9),(2,10),(3,0),(3,1),(3,2),(3,3),(3,4),(3,5),(3,6),(3,7),(3,8),(3,9),(3,10),(4,0),(4,1),(4,2),(4,3),(4,4),(4,5),(4,6),(4,7),(4,8),(4,9),(4,10),(5,0),(5,1),(5,2),(5,3),(5,4),(5,5),(5,6),(5,7),(5,8),(5,9),(5,10),(6,0),(6,1),(6,2),(6,3),(6,4),(6,5),(6,6),(6,7),(6,8),(6,9),(6,10),(7,0),(7,1),(7,2),(7,3),(7,4),(7,5),(7,6),(7,7),(7,8),(7,9),(7,10),(8,0),(8,1),(8,2),(8,3),(8,4),(8,5),(8,6),(8,7),(8,8),(8,9),(8,10),(9,0),(9,1),(9,2),(9,3),(9,4),(9,5),(9,6),(9,7),(9,8),(9,9),(9,10),(10,0),(10,1),(10,2),(10,3),(10,4),(10,5),(10,6),(10,7),(10,8),(10,9),(10,10)], Output);
    fail).

value(GameState, Color, Value):-
    length(GameState, L),
    indexes_from_length(L, ToVisit),
    algorithm(GameState, Color, ToVisit, 0, [], Value).


% ----------------------------------------------------------------
