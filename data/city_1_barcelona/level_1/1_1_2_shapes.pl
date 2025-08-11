
:- ['1_1_map'].

level_extends('1_1', '1_1_2').

shape('Jordi', '1_1_2').
shape('Aurora', '1_1_2').

needs_status(shape('Jordi', '1_1_2'), 'Window').
wants_alone(shape('Aurora', '1_1_2')).

% init_level('1_1_2').
solve_1_1_2 :- solve_game('1_1_2').