:- ['1_2_map'].

shape('Kaari').
needs_adj_shape('Kaari', 'Aria').

shape('Aria').
produces_status('Aria', stinky).

shape('Alexis').
needs_status('Alexis', 'Window').

shape('Kai').
produces_status('Kai', stinky).


shape('Kori').
wants_alone('Kori').

shape('Nat').
needs_adj_shape('Nat', 'Alexis').
dislikes_status('Nat', stinky).

shape('Anabela').
dislikes_status('Anabela', stinky).


