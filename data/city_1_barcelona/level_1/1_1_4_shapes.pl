
:- ['1_1_map'].

level_extends('1_1', '1_1_4').

shape('Shape1', '1_1_4').
shape('Shape2', '1_1_4').
shape('Shape3', '1_1_4').

needs_status(shape('Shape1', '1_1_4'), 'Window').
needs_adj_shape(shape('Shape3', '1_1_4'), 'Shape1').
needs_status(shape('Shape2', '1_1_4'), 'Window').

level_state('1_1_4', Sol_1_1_4).
solve_1_1_4 :- solve_game('1_1_4').