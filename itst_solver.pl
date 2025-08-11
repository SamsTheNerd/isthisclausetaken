:- [coredefs].

% import this in each level def and just call it from there I suppose?

shapename_to_shapeobj(Level, ShapeName, ShapeObj) :- ShapeObj = shape(ShapeName, Level).

make_shape_seat_for_seat(Seat, ShapeSeat, Shape) :-
    ShapeSeat = shape_seat(Shape, Seat).

make_shape_seat_for_shape(Shape, ShapeSeat, Seat) :-
    ShapeSeat = shape_seat(Shape, Seat).

alldifshapes([], _).
alldifshapes([shape('Empty', _) |Es], Options) :- alldifshapes(Es, Options).
alldifshapes([E|Es], Options) :-
    % freeze(E, member(E, Options)),
    maplist(dif(E), Es),
    alldifshapes(Es, Options).

alldif([]).
alldif([E|Es]) :-
    maplist(dif(E), Es),
    alldif(Es).

verify_shape_seating(shape_seat(Shape, Seat)) :- 
    shape_in_seat(Shape, Seat).

solve_game(Level) :- 
    % get all shapes in this level
    findall(Shape, (Shape = shape(ShapeName, Level), Shape, ShapeName \= 'Empty'), AllShapes),
    % write(AllShapes), write('\n'),
    % get all seats in this level
    findall(Seat, (Seat = seat(_, Level), Seat), AllSeats),
    % attach seat variables for each shape
    maplist(make_shape_seat_for_shape, AllShapes, ShapeSeats, SeatVars),
    % store our shape seats in the level
    get_shape_seats(Level, ShapeSeats),
    write(SeatVars), write('\n'),
    % subset(SeatVars, AllSeats),
    alldif(SeatVars),
    maplist(verify_shape_seating, ShapeSeats),
    % get_shape_seats(Level, ShapeSeatsAgain),
    write(ShapeSeats).