:- [itst_solver].

seat('1').
seat('2').
seat('3').

adjacent_seat_mapdef('1', '2').
adjacent_seat_mapdef('2', '3').

nearby_seat_mapdef('1', '3').

seat_status_def('1', 'Window').
seat_status_def('3', 'Window').