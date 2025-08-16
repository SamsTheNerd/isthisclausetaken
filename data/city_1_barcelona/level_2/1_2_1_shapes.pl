:- ['1_2_map'].

shape('Anna').
wants_alone('Anna').

shape('Charlie').
needs_status('Charlie', 'Window').

shape('Olivia').
needs_status('Olivia', 'Window').
needs_adj_shape('Olivia', 'Goren').

shape('David').
wants_alone('David').

shape('Goren').
needs_adj_shape('Goren', 'Olivia').
needs_status('Goren', 'VehicleDir').
