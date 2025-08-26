:- ['1_2_map'].

shape('Victor').
produces_status('Victor', stinky).

shape('Jayden').
dislikes_status('Jayden', stinky).

shape('Joao').
needs_adj_shape('Joao', 'Ausias').
needs_status('Joao', 'Window').

shape('Ausias').
needs_status('Ausias', 'Window').
% V that doesn't work?
dislikes_status('Ausias', stinky).

shape('Roshan').
wants_alone('Roshan').

shape('Lucia').
produces_status('Lucia', stinky).
needs_status('Lucia', 'Window').