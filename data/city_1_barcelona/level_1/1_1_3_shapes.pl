
:- ['1_1_map'].

level_extends('1_1', '1_1_3').

shape('Shape1', '1_1_3').
shape('Shape2', '1_1_3').
% shape('Shape3', '1_1_3').

needs_status(shape('Shape1', '1_1_3'), 'Window').
needs_status(shape('Shape2', '1_1_3'), 'Window').

solve_1_1_3 :- solve_game('1_1_3').