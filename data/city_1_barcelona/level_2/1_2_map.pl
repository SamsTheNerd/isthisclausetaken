:- [itst_solver].

two_hop_nearby.

seat('left1').
seat('left2').
seat('left3').

adjacent_seat_mapdef('left1', 'left2').
adjacent_seat_mapdef('left2', 'left3').

seat_status_def('left1', 'Window').
seat_status_def('left3', 'Window').

seat_status_def('left1', 'VehicleDir').
seat_status_def('left2', 'VehicleDir').
seat_status_def('left3', 'VehicleDir').

seat('mid1').
seat('mid2').
seat('mid3').

adjacent_seat_mapdef('mid1', 'mid2').
adjacent_seat_mapdef('mid2', 'mid3').

nearby_seat_mapdef('mid1', 'left1').
nearby_seat_mapdef('mid3', 'right1').

seat_status_def('mid1', 'Window').
seat_status_def('mid2', 'Window').
seat_status_def('mid3', 'Window').


seat('right1').
seat('right2').
seat('right3').

adjacent_seat_mapdef('right1', 'right2').
adjacent_seat_mapdef('right2', 'right3').

seat_status_def('right1', 'Window').
seat_status_def('right3', 'Window').

