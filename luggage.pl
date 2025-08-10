:- use_module(library(clpfd)).

% define luggage shapes as lists of xy offsets
luggage_shape('2x2', [xy(0,0), xy(0,1), xy(1,0), xy(1,1)]).
luggage_shape('1x1', [xy(0,0)]).
luggage_shape('1x2', [xy(0,0), xy(0,1)]).
luggage_shape('2x1', [xy(0,0), xy(1,0)]).
luggage_shape('1x3', [xy(0,0), xy(0,1), xy(0,2)]).
luggage_shape(trumpet, [xy(1,0), xy(0,1), xy(1,1)]).

add_xys(xy(XL, YL), xy(XR, YR), xy(ResX, ResY)) :- ResX #= XL + XR, ResY #= YL + YR.

% def: luggage(Symbol, Shape, xy(PosX, PosY))

% luggage_to_positions(Luggage, ListOfPositions)
luggage_to_positions(luggage(_, LuggageShape, LugOffset), LugXYs) :- 
    luggage_shape(LuggageShape, XYs),
    maplist(add_xys(LugOffset), XYs, LugXYs).
    

enforce_bounds(Width, Height, xy(X,Y)) :- WidthExc is Width - 1, HeightExc is Height - 1,
    between(0, WidthExc, X), between(0, HeightExc, Y).

xy_to_index(Width, xy(X,Y), Idx) :- Idx #= ((Y * Width) + X).

% 
unique_elems([]).
unique_elems([X | Xs]) :- \+ member(X, Xs), unique_elems(Xs).

solve_luggage(Luggages, Width, Height) :- 
    % get a list of luggage shape positions: LuggagesAbsPoss :: [[xy]]
    maplist(luggage_to_positions, Luggages, LuggagesAbsPoss),
    % flatten it so we can work on the luggage units individually: LugAbsPoss :: [xy]
    flatten(LuggagesAbsPoss, LugAbsPoss),
    maplist(enforce_bounds(Width, Height), LugAbsPoss), 
    maplist(xy_to_index(Width), LugAbsPoss, LugAbsIdxs),
    unique_elems(LugAbsIdxs).

make_pair(L, R, pair(L, R)).

% luggage to a list of pairs of its positions and symbols
luggage_to_symbol_poses(Lug, SymPos) :- 
    Lug = luggage(Sym, _, _),
    luggage_to_positions(Lug, LugAbsPoss),
    maplist(make_pair(Sym), LugAbsPoss, SymPos).

print_luggage_res(Luggages, Width, Height, X, Y) :- Y =:= Height.
print_luggage_res(Luggages, Width, Height, X, Y) :- X =:= Width, write('\n'), print_luggage_res(Luggages, Width, Height, 0, Y+1).
print_luggage_res(Luggages, Width, Height, X, Y) :- 
    ((maplist(luggage_to_symbol_poses, Luggages, LugSyms),
    flatten(LugSyms, SymPoss),
    XE is X, YE is Y,
    member(pair(Sym, xy(XE, YE)), SymPoss), 
    write(Sym)) ; write('.')), print_luggage_res(Luggages, Width, Height, X+1, Y).

test :- Luggages = [
        luggage('A', '2x2', APos),
        luggage('B', '1x1', BPos),
        luggage('C', 'trumpet', CPos),
        luggage('D', '1x1', DPos),
        luggage('E', '2x1', EPos),
        luggage('F', '1x3', FPos)
    ],
    solve_luggage(Luggages, 3, 5), 
    print_luggage_res(Luggages, 3, 5, 0, 0).

% test :- solve_luggage([
%         luggage('A', '2x2', APos)
%     ], 3, 4).