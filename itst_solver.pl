:- [coredefs].

% import this in each level def and just call it from there I suppose?

alldifshapes([], _).
alldifshapes([shape('Empty', Level) | Es], Level) :- alldifshapes(Es, Level).
alldifshapes([E|Es], Level) :-
    maplist(dif(E), Es),
    alldifshapes(Es, Level).

alldif([]).
alldif([E|Es]) :-
    maplist(dif(E), Es),
    alldif(Es).

add_shape_based_fact(Shape, SeatVar, Fact) :- 
    % assertz(shape_in_seat(Shape, SeatVar) :- \+ bad_shape_seat(Shape, SeatVar)).
    % Fact = ((shape_in_seat(Shape, SeatVar) :- \+ bad_shape_seat(Shape, SeatVar))).
    % freeze(SeatVar, \+ bad_shape_seat(Shape, SeatVar)),
    Fact = (shape_in_seat(Shape, SeatVar)).

add_seat_based_fact(Seat, ShapeVar, Fact) :- 
    % assertz(shape_in_seat(ShapeVar, Seat) :- \+ bad_shape_seat(ShapeVar, Seat)).
    % asserta(shape_in_seat(ShapeVar, Seat)).
    % Fact = ((shape_in_seat(ShapeVar, Seat) :- \+ bad_shape_seat(ShapeVar, Seat))).
    % freeze(ShapeVar, \+ bad_shape_seat(ShapeVar, Seat)),
    Fact = (shape_in_seat(ShapeVar, Seat)).

add_empty_seat_facts(_, 0, [], []).
add_empty_seat_facts(Level, N, [SeatVar | SeatVars], [Fact, Facts]) :- 
    Shape = shape('Empty', Level),
    % assertz(shape_in_seat(Shape, SeatVar) :- \+ bad_shape_seat(Shape, SeatVar)),
    % Fact = (shape_in_seat(Shape, SeatVar) :- \+ bad_shape_seat(Shape, SeatVar)),
    Fact = (shape_in_seat(Shape, SeatVar)),
    % freeze(SeatVar, \+ bad_shape_seat(Shape, SeatVar)),
    Next is N - 1,
    add_empty_seat_facts(Level, Next, SeatVars, Facts).

verify_shape(Shape, Seat) :- 
    % write('verify shape\n'),
    % write('verify?\n'),
    shape_in_seat(Shape, Seat),
    freeze(Seat, \+ bad_shape_seat(Shape, Seat)),
    % \+ bad_shape_seat(Shape, Seat),
    ground(Seat), Seat.


verify_seat(Seat, Shape) :- 
    % write('verify shape\n'),
    % write('verify?\n'),
    shape_in_seat(Shape, Seat),
    freeze(Shape, \+ bad_shape_seat(Shape, Seat)),
    % \+ bad_shape_seat(Shape, Seat),
    ground(Seat), Seat.

print_seating(Seat) :-
    shape_in_seat(Shape, Seat),
    Seat = seat(SeatName, _),
    Shape = shape(ShapeName, _),
    findall(Sh, (shape_in_seat(Sh, Seat), ground(Sh)), Shapes),
    write(SeatName), write(': '), write(ShapeName), write(' | '), write(Shapes), write('\n').

print_seating_for_shape(Shape) :-
    shape_in_seat(Shape, Seat),
    Seat = seat(SeatName, _),
    Shape = shape(ShapeName, _),
    findall(Se, (shape_in_seat(Shape, Se), ground(Se)), Seats),
    write(ShapeName), write(': '), write(SeatName), write(' | '), write(Seats), write('\n').

solve_game(Level) :- 
    % get all shapes and seats in the level
    findall(Shape, (Shape = shape(ShapeName, Level), Shape, ShapeName \= 'Empty'), AllShapes),
    write('All Shapes: '), write(AllShapes), write('\n'),
    findall(Seat, (Seat = seat(_, Level), Seat), AllSeats),
    % add facts for each that map it to a free var of the other type
    maplist(add_shape_based_fact, AllShapes, SeatVarsForShapes, ShapeFacts),
    write('Seat Vars For Shapes: '), write(SeatVarsForShapes), write('\n'),
    maplist(add_seat_based_fact, AllSeats, ShapeVarsForSeats, SeatFacts),
    write('Shape Vars for Seats: '), write(ShapeVarsForSeats), write('\n'),
    % add shape_in_seat(empty, SeatVar) fact for each empty seat
    length(AllSeats, SeatCount), length(AllShapes, ShapeCount),
    EmptyCount is SeatCount - ShapeCount,
    add_empty_seat_facts(Level, EmptyCount, EmptySeatVars, EmptySeatFacts),
    append([SeatVarsForShapes, EmptySeatVars], AllSeatVars),


    alldif(AllSeatVars),
    % make our shape vars unique except for empty seats. hopefully the limit on the number of empty seat facts keeps everything in order?
    alldifshapes(ShapeVarsForSeats, Level),
    subset(AllSeatVars, AllSeats),
    % subset(ShapeVarsForSeats, [shape('Empty', Level) | AllShapes]),
    findall(EmptiesIdx, nth0(EmptiesIdx, ShapeVarsForSeats, shape('Empty', Level)), EmptyIdxs),
    length(EmptyIdxs, EmptyCount),
    maplist(assertz, ShapeFacts), maplist(assertz, SeatFacts), maplist(assertz, EmptySeatFacts),

    maplist(print_seating, AllSeats),
    maplist(print_seating_for_shape, AllShapes),

    % findall((Sh, Se, '\n'), (shape_in_seat(Sh, Se)), ShapeSeats), 
    % write(ShapeSeats),

    % get all our seat vars together and make sure they're unique. ie, no shapes can share a seat
    % write('Seat Vars For All: '), write(AllSeatVars), write('\n'),
    % shape_in_seat(TestShape, seat('2', '1_1_2')),
    % write(TestShape),

    
    maplist(verify_shape, AllShapes, SeatResults),
    maplist(verify_seat, AllSeats, ShapeResults),
    % print(SeatResults),

    maplist(print_seating, AllSeats),
    maplist(print_seating_for_shape, AllShapes).