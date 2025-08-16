:- [itst_solver].

seat('left1').
seat('left2').
seat('left3').

adjacent_seat_mapdef('left1', 'left2').
adjacent_seat_mapdef('left2', 'left3').
nearby_seat_mapdef('left1', 'left3').

seat_status('left1', 'Window').
seat_status('left3', 'Window').

seat_status('left1', 'VehicleDir').
seat_status('left2', 'VehicleDir').
seat_status('left3', 'VehicleDir').

seat('right1').
seat('right2').
seat('right3').

adjacent_seat_mapdef('right1', 'right2').
adjacent_seat_mapdef('right2', 'right3').
nearby_seat_mapdef('right1', 'right3').

seat_status('right1', 'Window').
seat_status('right3', 'Window').


seat('mid1').
seat('mid2').
seat('mid3').

adjacent_seat_mapdef('mid1', 'mid2').
adjacent_seat_mapdef('mid2', 'mid3').
nearby_seat_mapdef('mid1', 'mid3').

seat_status('mid1', 'Window').
seat_status('mid2', 'Window').
seat_status('mid3', 'Window').