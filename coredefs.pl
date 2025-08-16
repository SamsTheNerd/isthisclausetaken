% shapes and seats can be atoms with a world atom attached maybe?

:- multifile seat/1.
:- multifile shape/1.
:- dynamic shape/1.

% shape('Empty'). 

:- multifile adjacent_seat/2.
:- multifile nearby_seat/2.

:- dynamic non_adj_seat/2.
:- dynamic non_nearby_seat/2.

:- dynamic all_adj_seats/2.
:- dynamic all_nearby_seats/2.
:- dynamic all_non_adj_seats/2.
:- dynamic all_non_nearby_seats/2.

:- multifile adjacent_seat_mapdef/2.
:- multifile nearby_seat_mapdef/2.

:- dynamic shape_in_seat/2.

% shape_seating_requirement(Shape, RequirementName, Data) - indicates that a shape has a given requirement
:- multifile shape_seating_requirement/3. 

% requirement_predicate(Shape, Seat, Requirement) - defines the predicate for verifying a requirement
:- multifile requirement_predicate/3.

% indicates a shape needs a given status in the seat they are in (like window)
:- multifile needs_status/2. 

shape_seating_requirement(Shape, 'req_needs_status_in_seat', Status) :- needs_status(Shape, Status).

requirement_predicate(Shape, Seat, 'req_needs_status_in_seat') :- 
    findall(Status, shape_seating_requirement(Shape, 'req_needs_status_in_seat', Status), AllNeededStatus),
    maplist(seat_status(Seat), AllNeededStatus).

% indicates a shape needs to not be in a seat with the given status (like stinky)
:- multifile dislikes_status/2.

shape_seating_requirement(Shape, 'req_dislikes_status_in_seat', Status) :- dislikes_status(Shape, Status).

requirement_predicate(Shape, Seat, 'req_dislikes_status_in_seat') :- 
    findall(Status, shape_seating_requirement(Shape, 'req_dislikes_status_in_seat', Status), AllDislikedStatus),
    maplist(seat_not_status(Seat), AllDislikedStatus).

% indicates a shape produces a status (like smells bad)
:- multifile produces_status/2.


% needs/dislikes nearby for like,, people or whatever
% needs_adj(Shape, ShapePredicate)
:- multifile needs_adj/2. 

shape_seating_requirement(Shape, 'req_needs_adj_pred', Pred) :- needs_adj(Shape, Pred).

adj_shape_with(Seat, Pred) :- 
    adjacent_seat(Seat, OtherSeat), shape_in_seat(Shape, OtherSeat), freeze(Shape, (call(Pred, Shape))).
    % write('Adj Shape to seat '), write(Seat), write(' is '), write(OtherSeat), write(' containing shape '), write(Shape), write('\n').

requirement_predicate(Shape, Seat, 'req_needs_adj_pred') :- 
    findall(Pred, shape_seating_requirement(Shape, 'req_needs_adj_pred', Pred), AllPreds),
    write(AllPreds),
    maplist(adj_shape_with(Seat), AllPreds).

% dislikes_adj(Shape, ShapePredicate) - force everything adjacent to match 
:- multifile all_adj_match/2.

shape_seating_requirement(Shape, 'req_all_adj_match', ShapePred) :- all_adj_match(Shape, ShapePred).

enforce_all_adj(Seat, Pred) :- all_adj_seats(Seat, Adjs), maplist(shape_in_seat, Adjs, Shapes), maplist(Pred, Shapes).

requirement_predicate(Shape, Seat, 'req_all_adj_match') :- 
    findall(Pred, shape_seating_requirement(Shape, 'req_all_adj_match', Pred), AllPreds),
    write(AllPreds),
    maplist(enforce_all_adj(Seat), AllPreds).

:- multifile needs_adj_shape/2.
needs_adj(Shape, =(NeedsShape)) :- needs_adj_shape(Shape, NeedsShape).

:- multifile wants_alone/1.
is_empty(empty(_)).
% all_adj_match(Shape, is_empty) :- wants_alone(Shape).

shape_seating_requirement(Shape, 'req_alone', _) :- wants_alone(Shape).

requirement_predicate(Shape, Seat, 'req_alone') :- 
    write('req alone\n'),
    all_adj_seats(Seat, Adjs),
    maplist(shape_in_seat, Adjs, Shapes),
    maplist(is_empty, Shapes).


% indicates a status spreads to adj seats - do any do this actually?
:- multifile adj_status/1.
% indicates a status spreads to nearby seats
:- multifile nearby_status/1.

% used to check and set seat status
:- multifile seat_status/2.

seat_not_status(Seat, Status) :-
    (seat(OtherSeat), seat_status(OtherSeat, Status)) -> dif(OtherSeat, Seat).

nearby_seat(S1, S2) :- nearby_seat_mapdef(S1, S2).
nearby_seat(S2, S1) :- nearby_seat_mapdef(S1, S2).
adjacent_seat(S1, S2) :- adjacent_seat_mapdef(S1, S2).
adjacent_seat(S2, S1) :- adjacent_seat_mapdef(S1, S2).

nearby_seat(S1, S2) :- adjacent_seat(S1, S2).


