:- dynamic path/1.

%This is my initializing predicate that takes an input of xvalues for start and
%finish, the maze, and the variable were placing path in. It starts by retracting 
%our path predicate (this isn't required but I used it to keep from allocating memory 
%incorrectly). Following that I assert my starting coordinates and call my movement. 
%After the movements complete I take my predicate from the dynamic predicate, reverse it,
%and assign it to path.
mazepath(X1,Y1,X2,Y2,Maze,Path,Length) :-
    retractall(path(_)),
    assert(path([[X1,Y1]|[]])),
	traverseMaze(X1,Y1,X2,Y2,Maze),
    retract(path(P)),
    reverse(P,Preverse),
    Path = Preverse,
    length(Path,N),
    Length = N,
    retractall(path(_)).

%Traverse maze is used to check for completion and call my next move predicate
traverseMaze(X1,Y1,X2,Y2,Maze) :-
    X1 =:= X2,
    Y1 =:= Y2;
    random(0,3,Dir),
    nextmove(Dir,X1,Y1,X2,Y2,Maze).

%This predicate defines my Or statement for traversing through my maze. 
%Its given the random direction and calls from the various move statements sequentally
nextmove(Dir,X1,Y1,X2,Y2,Maze) :-
    next(Dir,X1,Y1,X2,Y2,Maze);
	(   Dir1 is (Dir+3) mod 4, 
    	next(Dir1,X1,Y1,X2,Y2,Maze));
	(   Dir2 is (Dir+1) mod 4, 
    	next(Dir2,X1,Y1,X2,Y2,Maze));
	(   Dir3 is (Dir+2) mod 4,
    	next(Dir3,X1,Y1,X2,Y2,Maze));
    nextpass(Dir,X1,Y1,X2,Y2,Maze);
	(   Dir1 is (Dir+3) mod 4, 
    	nextpass(Dir1,X1,Y1,X2,Y2,Maze));
	(   Dir2 is (Dir+1) mod 4, 
    	nextpass(Dir2,X1,Y1,X2,Y2,Maze));
	(   Dir3 is (Dir+2) mod 4,
    	nextpass(Dir3,X1,Y1,X2,Y2,Maze)).

%This predicate is my east movement only called when the next movement is already in path.
%In this predicate definition I:
%Increment the value of our indecies.
%Check for wall.
%Check if member of path
%Call for movement again.
%0 east
next(0,X1,Y1,X2,Y2,Maze) :-
	X is X1 + 1,
	find(X,Y1,Maze,R),
    R \== 1,
    A is X,
    B is Y1,
    checkMember(A,B),
    retract(path(P)),
    assert(path([[A,B]|P])),
    traverseMaze(A,B,X2,Y2,Maze).

%Same as east next predicate but for west.
%1 west
next(1,X1,Y1,X2,Y2,Maze) :-
	X is X1 - 1,
	find(X,Y1,Maze,R),
    R \== 1,
    A is X,
    B is Y1, 
    checkMember(A,B),
    retract(path(P)),
    assert(path([[A,B]|P])),
    traverseMaze(A,B,X2,Y2,Maze).

%Same as east next predicate but for west.
%2 south
next(2,X1,Y1,X2,Y2,Maze) :-
	Y is Y1 - 1,
	find(X1, Y,Maze,R),
    R \== 1,
    A is X1,
    B is Y, 
    checkMember(A,B),
    retract(path(P)),
    assert(path([[A,B]|P])),
    traverseMaze(A,B,X2,Y2,Maze).

%Same as east next predicate but for west.
%3 north
next(3,X1,Y1,X2,Y2,Maze) :-
	Y is Y1 + 1,
	find(X1, Y,Maze,R),
    R \== 1,
    A is X1,
    B is Y,
    checkMember(A,B),
    retract(path(P)),
    assert(path([[A,B]|P])),
    traverseMaze(A,B,X2,Y2,Maze).



%This predicate is my east movement only called when the next movement is already in path.
%In this predicate definition I:
%Increment the value of our indecies.
%Check for wall.
%Take our path predicate from dynamic and assert it back.
%Check the head of the path if we're backtracking steps.
%If that check head fails then assert the path predicate as [a,b] on the head and tail of path.
%Call for movement again.
%0 east
nextpass(0,X1,Y1,X2,Y2,Maze) :-
	X is X1 + 1,
	find(X,Y1,Maze,R),
    R \== 1,
    A is X,
    B is Y1,
    retract(path(P)),
    \+checkHead(P,A,B,X2,Y2,Maze),
    assert(path([[A,B]|P])),
    traverseMaze(A,B,X2,Y2,Maze).

%Same as east nextpass predicate but for west.
%1 west
nextpass(1,X1,Y1,X2,Y2,Maze) :-
	X is X1 - 1,
	find(X,Y1,Maze,R),
    R \== 1,
    A is X,
    B is Y1,
    retract(path(P)),
    \+checkHead(P,A,B,X2,Y2,Maze),
    assert(path([[A,B]|P])),
    traverseMaze(A,B,X2,Y2,Maze).


%Same as east nextpass predicate but for south.
%2 south
nextpass(2,X1,Y1,X2,Y2,Maze) :-
	Y is Y1 - 1,
	find(X1, Y,Maze,R),
    R \== 1,
    A is X1,
    B is Y,     
    retract(path(P)),
    \+checkHead(P,A,B,X2,Y2,Maze),
    assert(path([[A,B]|P])),
    traverseMaze(A,B,X2,Y2,Maze).


%Same as east nextpass predicate but for north.
%3 north
nextpass(3,X1,Y1,X2,Y2,Maze) :-
	Y is Y1 + 1,
	find(X1, Y,Maze,R),
    R \== 1,
    A is X1,
    B is Y,
    retract(path(P)),
    \+checkHead(P,A,B,X2,Y2,Maze),
    assert(path([[A,B]|P])),
    traverseMaze(A,B,X2,Y2,Maze).

%This definition is used to find the value located at X,Y in maze.
find(X,Y,G,R) :-
    nth0(Y,G,Z),
    nth0(X,Z,R).

%This predicate checks if [a,b] is a member of the path already and fails if so
checkMember(A,B) :-
    retract(path(P)),
    assert(path(P)),
    \+member([A,B],P).

%This predicate is used to check if the head is the point we're returning to. 
%If it is it fails from here and goes back to the nextpass predicate. In nextpass 
%we use the fail as a pass case to move to the next line.
checkHead([H|T],A,B,X2,Y2,Maze) :-
	maplist(=, H, [A,B]),
    assert(path(T)),
    traverseMaze(A,B,X2,Y2,Maze).


