:- use_module(library(clpfd)).
:- use_module(library(apply)).

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

:- dynamic seat_status_antidef/2.

:- multifile adjacent_seat_mapdef/2.
:- multifile nearby_seat_mapdef/2.

:- multifile two_hop_nearby/0.

nearby_seat(S1, S2) :- two_hop_nearby, adjacent_seat(S1, I), adjacent_seat(I, S2), I \= S1, I \= S2.

get_seating_chart(game_state(SeatingChart), SeatingChart).


% shape_seating_requirement(Shape, RequirementName, Data) - indicates that a shape has a given requirement
:- multifile shape_seating_requirement/3. 

% seat_seating_requirement(Seat, RequirementName, Data) - same as shape_seating_requirement but on seats
:- multifile seat_seating_requirement/3. 

% requirement_predicate(GameState, Shape, Seat, Requirement) - defines the predicate for verifying a requirement
:- multifile requirement_predicate/4.

% indicates a shape needs a given status in the seat they are in (like window)
:- multifile needs_status/2. 

% indicates a status spreads to adj seats - do any do this actually?
:- multifile adj_status/1.
% indicates a status spreads to nearby seats
:- multifile nearby_status/1.
nearby_status(stinky).

% used to check and set seat status
:- multifile seat_status_def/2.

% seat_status(_, Shape, Status) :- seat_status_def(Shape, Status).


shape_seating_requirement(Shape, 'req_needs_adj_pred', Pred) :- needs_adj(Shape, Pred).

adj_shape_with(GameState, Seat, Pred) :- 
    get_seating_chart(GameState, SeatingChart),
    adjacent_seat(Seat, OtherSeat), shape_seat_lookup(SeatingChart, Shape, OtherSeat), 
    call(Pred, Shape).

requirement_predicate(GameState, Shape, Seat, 'req_needs_adj_pred') :- 
    findall(Pred, shape_seating_requirement(Shape, 'req_needs_adj_pred', Pred), AllPreds),
    % write(AllPreds),
    maplist(adj_shape_with(GameState, Seat), AllPreds).

% needs/dislikes nearby for like,, people or whatever
% needs_adj(Shape, ShapePredicate)
:- multifile needs_adj/2. 
needs_adj(Shape, =(NeedsShape)) :- needs_adj_shape(Shape, NeedsShape).



shape_seating_requirement(Shape, 'req_needs_status_in_seat', Status) :- needs_status(Shape, Status).

requirement_predicate(GameState, Shape, Seat, 'req_needs_status_in_seat') :- 
    findall(Status, shape_seating_requirement(Shape, 'req_needs_status_in_seat', Status), AllNeededStatus),
    maplist(seat_status(GameState, Seat), AllNeededStatus).


% indicates a shape needs to not be in a seat with the given status (like stinky)
:- multifile dislikes_status/2.

shape_seating_requirement(Shape, 'req_dislikes_status_in_seat', Status) :- dislikes_status(Shape, Status).

requirement_predicate(GameState, Shape, Seat, 'req_dislikes_status_in_seat') :- 
    findall(Status, shape_seating_requirement(Shape, 'req_dislikes_status_in_seat', Status), AllDislikedStatus),
    maplist(seat_not_status(GameState, Seat), AllDislikedStatus).

% indicates a shape produces a status (like smells bad)
:- multifile produces_status/2.

% dislikes_adj(Shape, ShapePredicate) - force everything adjacent to match 
:- multifile all_adj_match/2.

shape_seating_requirement(Shape, 'req_all_adj_match', ShapePred) :- all_adj_match(Shape, ShapePred).

enforce_all_adj(GameState, Seat, Pred) :- all_adj_seats(Seat, Adjs), get_seating_chart(GameState, SeatingChart), maplist(seat_shape_lookup(SeatingChart), Adjs, Shapes), maplist(Pred, Shapes).

requirement_predicate(GameState, Shape, Seat, 'req_all_adj_match') :- 
    findall(Pred, shape_seating_requirement(Shape, 'req_all_adj_match', Pred), AllPreds),
    % write(AllPreds),
    maplist(enforce_all_adj(GameState, Seat), AllPreds).

same_shape(ShapeName, Shape) :- write(ShapeName), write('='), write(Shape), write('\n'), ShapeName = Shape, write('yay').

:- multifile needs_adj_shape/2.
% needs_adj(Shape, same_shape(NeedsShape)) :- needs_adj_shape(Shape, NeedsShape).


:- multifile wants_alone/1.
is_empty(empty(N)).
all_adj_match(Shape, is_empty) :- wants_alone(Shape).


seat_shape_lookup(SeatingChart, Seat, Shape) :- member((Shape, Seat), SeatingChart).
shape_seat_lookup(SeatingChart, Shape, Seat) :- member((Shape, Seat), SeatingChart).


% structure to determine if a seat has a status

seat_status_provider_type/1.
seat_status_provided/4.
seat_status_not_provided/4.

seat_not_status(GameState, Seat, Status) :-
    findall(SPT, seat_status_provider_type(SPT), StatProviderTypes),
    maplist(seat_status_not_provided(GameState, Seat, Status), StatProviderTypes).

seat_status(GameState, Seat, Status) :- 
    findall(SPT, seat_status_provider_type(SPT), StatProviderTypes),
    convlist(seat_status_provided(GameState, Seat, Status), StatProviderTypes, Res),
    member(_, Res). % not empty

% 'static_shape_provided' stuff

seat_status_provider_type('static_shape_provided').

seat_status_provided(GameState, Seat, Status, 'static_shape_provided', res) :-
    nearby_status(Status),
    produces_status(StatShape, Status),
    get_seating_chart(GameState, SeatingChart),
    shape_seat_lookup(SeatingChart, StatShape, ProducerSeat),
    nearby_seat(Seat, ProducerSeat).

seat_status_not_provided(GameState, Seat, Status, 'static_shape_provided') :-
    findall(StatShape, produces_status(StatShape, Status), StatProducers),
    get_seating_chart(GameState, SeatingChart),
    maplist(shape_seat_lookup(SeatingChart), StatProducers, StatProducerSeats),
    all_non_nearby_seats(Seat, NonNearbies),
    subset(StatProducerSeats, NonNearbies).

seat_status_provider_type('status_def_in_seat').
seat_status_provided(GameState, Seat, Status, 'status_def_in_seat', res) :- seat_status_def(Seat, Status).
seat_status_not_provided(GameState, Seat, Status, 'status_def_in_seat') :- findall(S, seat_status_def(S, Status), []) ; seat_status_antidef(Seat, Status).

nearby_seat(S1, S2) :- nearby_seat_mapdef(S1, S2).
nearby_seat(S2, S1) :- nearby_seat_mapdef(S1, S2).
adjacent_seat(S1, S2) :- adjacent_seat_mapdef(S1, S2).
adjacent_seat(S2, S1) :- adjacent_seat_mapdef(S1, S2).

nearby_seat(S1, S2) :- adjacent_seat(S1, S2).

is_status_involved(Status) :- produces_status(_, Status) ; needs_status(_, Status) ; dislikes_status(_, Status).
