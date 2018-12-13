lines([])           --> call(eos), !.
lines([Line|Lines]) --> line(Line), lines(Lines).

eos([], []).

line([])     --> ( "\n" ; call(eos) ), !.
line([L|Ls]) --> [L], line(Ls).

list([]) --> [10], !.
   
list([L|Ls]) --> [L], list(Ls).

liness([])           --> call(eos), !.
liness([Line|Lines]) --> linee(Linee), {append(Linee, [10], Line)}, liness(Lines).

linee([])     --> ( "\n" ; call(eos) ), !.
linee([L|Ls]) --> [L], linee(Ls).

anything --> [].
anything --> [_], anything.

down(Y, Z) :- pparent(Y, Z), Z \= 0, Y \= 0.
up(X, Z) :- pparent(Z, X), X \= 0, Z \= 0.

check([[Point | Path] | _], [Point | Path], End):-Point=End.
check([_|T], Solution, End):-check(T, Solution, End).

solvebfs( Start, End, Solution) :-check([ [Start] ], Solution, End);
    bfs( [ [Start] ], Solution, End).

bfs( [ [X | Path] | Paths], Solution, End ) :-
 (bagof( [X1, X | Path ],
 ( up(X, X1), \+ member( X1, [X | Path])),
   NewPaths1) ; NewPaths1=[]),
 (bagof( [X1, X | Path ],
 ( down(X, X1), \+ member( X1, [X | Path])),
   NewPaths2) ; NewPaths2=[]),
 append(NewPaths1, NewPaths2, NewPaths),
 length(NewPaths, Size), Size \= 0,
 append( Paths, NewPaths, Paths1), !,
(check(NewPaths, Solution, End) ; bfs( Paths1, Solution, End)); bfs( Paths, Solution, End).