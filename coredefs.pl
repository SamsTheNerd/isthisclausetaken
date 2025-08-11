% shapes and seats can be atoms with a world atom attached maybe?

:- multifile seat/2.
:- multifile shape/2.

% shape('Empty', _). 

% shape_status(Shape, Status)
% seat_status(Seat, Status)

% adjacent_seat(Seat, Seat).
% nearby_seat(Seat, Seat).

% so like level_extends('1_1', '1_1_1') - i'm starting to think the whole level system is stupid,,
:- multifile level_extends/2.

:- multifile adjacent_seat/2.
:- multifile nearby_seat/2.

:- multifile adjacent_seat_mapdef/3.
:- multifile nearby_seat_mapdef/3.


% indicates a shape needs a given status in the seat they are in (like window)
:- multifile needs_status/2. 
% indicates a shape needs to not be in a seat with the given status (like stinky)
:- multifile dislikes_status/2.
% indicates a shape produces a status (like smells bad)
:- multifile produces_status/2.

% needs/dislikes nearby for like,, people or whatever
% needs_adj(Shape, ShapePredicate)
:- multifile needs_adj/2. 
% dislikes_adj(Shape, ShapePredicate)
:- multifile dislikes_adj/2.

:- multifile needs_adj_shape/2.
:- multifile wants_alone/1.

% indicates a status spreads to adj seats - do any do this actually?
:- multifile adj_status/1.
% indicates a status spreads to nearby seats
:- multifile nearby_status/1.

% used to check and set seat status
:- multifile seat_status/2.

seat_status(Seat, Status) :- 
    Seat = seat(SeatName, Level),
    level_extends(LevelBase, Level),
    seat_status(seat(SeatName, LevelBase), Status).

seat(SeatName, Level) :- 
    level_extends(LevelBase, Level),
    seat(SeatName, LevelBase).

nearby_seat(seat(S1, Level), seat(S2, Level)) :- nearby_seat_mapdef(S1, S2, Level).
nearby_seat(seat(S2, Level), seat(S1, Level)) :- nearby_seat_mapdef(S1, S2, Level).
adjacent_seat(seat(S1, Level), seat(S2, Level)) :- adjacent_seat_mapdef(S1, S2, Level).
adjacent_seat(seat(S2, Level), seat(S1, Level)) :- adjacent_seat_mapdef(S1, S2, Level).

nearby_seat(seat(S1, Level), seat(S2, Level)) :- level_extends(LevelBase, Level), nearby_seat(seat(S1, LevelBase), seat(S2, LevelBase)).
adjacent_seat(seat(S1, Level), seat(S2, Level)) :- level_extends(LevelBase, Level), adjacent_seat(seat(S1, LevelBase), seat(S2, LevelBase)).

nearby_seat(S1, S2) :- nearby_seat(S2, S1).
nearby_seat(S1, S2) :- adjacent_seat(S1, S2).

% adjacent_seat(S1, S2) :- adjacent_seat(S2, S1).


:- multifile level_state/2. % level -> lstate(shape_seats, toggles, items)

get_shape_seats(Level, ShapeSeats) :- level_state(Level, lstate(ShapeSeats, _, _)).

% bad_shape_seat(Shape, Seat). indicates the shape CANT go in that seat

% can't go in a seat if someone else is there
bad_shape_seat(Shape, Seat) :- OtherShape \= Shape, OtherShape, shape_in_seat(OtherShape, Seat).

bad_shape_seat(Shape, Seat) :- OtherSeat \= Seat, OtherSeat, shape_in_seat(Shape, OtherSeat).

shape_in_seat(Shape, Seat) :- 
    write('shape_in_seat_start: '), write(Shape), write(' '), write(Seat), write('\n'),
    Shape = shape(ShapeName, ShapeLevel),
    Seat = seat(_, SeatLevel), 
    Shape, Seat,
    SeatLevel = ShapeLevel,
    get_shape_seats(SeatLevel, ShapeSeats),
    write('pre-bad: '), write(Shape), write(' '), write(Seat), write('\n'),
    \+ bad_shape_seat(Shape, Seat),
    write('post-bad: '), write(Shape), write(' '), write(Seat), write('\n'),
    member(shape_seat(Shape, SeatAns), ShapeSeats),
    SeatAns = Seat,
    write('\n - shape_in_seat: '), write(Shape), write(' '), write(Seat), write('\n').

unique_elems([]).
unique_elems([X | Xs]) :- \+ member(X, Xs), unique_elems(Xs).

bad_shape_seat(Shape, Seat) :- 
    % write('mrrp'), write(Shape), write(Seat),
    needs_status(Shape, Status),
    % write('unmet status: '), write(Shape), write(' '), write(Seat), write(': '), write(Status), write('\n'),
    \+ seat_status(Seat, Status).

bad_shape_seat(Shape, Seat) :- 
    % write(Shape), write(Seat),
    needs_adj(Shape, AdjPredicate),
    adjacent_seat(Seat, AdjSeat),
    shape_in_seat(AdjShape, AdjSeat),
    \+ call(AdjPredicate, AdjShape).

% bad_shape_seat(Shape, Seat) :- 
%     dislikes_adj(Shape, AdjPredicate),
%     Seat = seat(_, Level),
%     % adjacent_seat(Seat, AdjSeat),
%     findall(AS, adjacent_seat(AS, Seat), AdjSeats),
%     write(AdjSeats),
%     \+ maplist(shape_in_seat(shape('Empty', Level)), AdjSeats).
%     % write('dislike into shape_in_seat'),
%     % shape_in_seat(AdjShape, AdjSeat),
%     % write('\nadjshape: '), write(AdjShape),
%     % call(AdjPredicate, AdjShape).
%     % write('disliked seat: '), write(Shape), write(' '), write(Seat), write(': '), write(AdjPredicate), write('\n').

shape_property_def_impl :- 
    (needs_adj_shape(Shape, AdjShapeName) -> needs_adj(Shape, shape_named(AdjShapeName))).
shape_property_def_impl.

dislikes_adj(Shape, any_shape) :- wants_alone(Shape).

% bad_shape_seat(Shape, Seat) :-
%     wants_alone(Shape),
%     adjacent_seat(Seat, AdjSeat),
%     seat_is_taken(AdjSeat).

shape_named(ShapeName, shape(ShapeName, _)) :- write(ShapeName).
any_shape(shape(_, _)).

