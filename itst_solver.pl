:- [coredefs].

% import this in each level def and just call it from there I suppose?

alldif([]).
alldif([E|Es]) :-
    maplist(dif(E), Es),
    maplist(\=(E), Es),
    alldif(Es).

seating_is_ok(Shape, Seat) :- 
    findall(Req, shape_seating_requirement(Shape, Req, _), AllReqs),
    maplist(requirement_predicate(Shape, Seat), AllReqs).

verify_seating((Shape, Seat)) :- 
    % write('verify: '), write(Shape), write(': '), write(Seat), write('\n'),
    % freeze((Shape, Seat), (write('verify: '), write(Shape), write(': '), write(Seat), write('\n'), seating_is_ok(Shape, Seat))).
    seating_is_ok(Shape, Seat).

assert_non_adj((I1, I2)) :- assertz(non_adj_seat(I1, I2)).
assert_non_nearby((I1, I2)) :- assertz(non_nearby_seat(I1, I2)).

print_seating(Shape) :- 
    findall(Seat, (shape_in_seat(Shape, Seat)), Seats),
    % shape_in_seat(Shape, Seats),
    write(Shape), write(': '), write(Seats), write('\n').

print_seat_info(SeatingChart, Seat) :-
    member((Shape, Seat), SeatingChart),
    write(Seat), write(': '), write(Shape), write('\n').

make_empties(0, []).
make_empties(N, [E | Es]) :- Next is N - 1, E = empty(Next), assertz(shape(E)), make_empties(Next, Es).

make_seating_chart(0, [], [], []).
make_seating_chart(SeatCount, [(ShapeVar, SeatVar) | SCs], [ShapeVar | Shs], [SeatVar | Ses]) :-
    Next is SeatCount - 1,
    assertz(shape_in_seat(ShapeVar, SeatVar)), make_seating_chart(Next, SCs, Shs, Ses).

make_seating_lists(Seat) :- 
    findall(Adj, adjacent_seat(Seat, Adj), Adjs),
    assertz(all_adj_seats(Seat, Adjs)),
    findall(NAdj, non_adj_seat(Seat, NAdj), NAdjs),
    assertz(all_non_adj_seats(Seat, NAdjs)),
    findall(Nearby, nearby_seat(Seat, Nearby), Nearbys),
    assertz(all_nearby_seats(Seat, Nearbys)),
    findall(NNearby, non_nearby_seat(Seat, NNearby), NNearbys),
    assertz(all_non_nearby_seats(Seat, NNearbys)).

% where we define a lot of our hardcoded negations
game_init :-
    % get all shapes and seats in the level
    findall(Shape, shape(Shape), AllShapes),
    write('All Shapes: '), write(AllShapes), write('\n'),
    % define non adj/nearby relations
    findall(Seat, seat(Seat), AllSeats),
    length(AllShapes, ShapeCount),
    length(AllSeats, SeatCount),
    EmptySeatCount is SeatCount - ShapeCount,
    make_empties(EmptySeatCount, EmptyShapes),

    findall((S1, S2), (seat(S1), seat(S2), dif(S1, S2)), AllSeatRelations),

    findall((S1, S2), (seat(S1), seat(S2), adjacent_seat(S1, S2)), AdjSeats),
    subtract(AllSeatRelations, AdjSeats, NonAdjSeats),
    maplist(assert_non_adj, NonAdjSeats),

    findall((S1, S2), (seat(S1), seat(S2), nearby_seat(S1, S2)), NearbySeats),
    subtract(AllSeatRelations, NearbySeats, NonNearbySeats),
    maplist(assert_non_nearby, NonNearbySeats),

    maplist(make_seating_lists, AllSeats),

    append([AllShapes, EmptyShapes], AllAndEmptyShapes),

    make_seating_chart(SeatCount, SeatingChart, ShapeVars, SeatVars),
    alldif(ShapeVars),
    alldif(SeatVars),
    maplist(shape, ShapeVars),
    !,
    maplist(seat, SeatVars),
    maplist(verify_seating, SeatingChart),
    maplist(nonvar, SeatVars),
    maplist(print_seat_info(SeatingChart), AllSeats),
    write('Seating Chart: '), write(SeatingChart), write('\n').