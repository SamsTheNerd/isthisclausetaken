:- [itst_solver].

seat('1', '1_1').
seat('2', '1_1').
seat('3', '1_1').

adjacent_seat_mapdef('1', '2', '1_1').
adjacent_seat_mapdef('2', '3', '1_1').

nearby_seat_mapdef('1', '3', '1_1').

seat_status(seat('1', '1_1'), 'Window').
seat_status(seat('3', '1_1'), 'Window').