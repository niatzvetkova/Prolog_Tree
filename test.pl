% To load in Prolog,:
% swipl
% ?- [Prolog_Courses].
  

:- op(500,xfx,'is_parent').


000 is_parent 100.
000 is_parent 103.
000 is_parent 110.
000 is_parent 121.

103 is_parent 107.
103 is_parent 203.

121 is_parent 221. % MAYBE CHANGE THIS CUZ NOT TECHNICALLY TREE

110 is_parent 302.
110 is_parent 303.
110 is_parent 210.
110 is_parent 221.

302 is_parent 406.

210 is_parent 319.
210 is_parent 311.
210 is_parent 312.
210 is_parent 330.

221 is_parent 213221.
221 is_parent 322.
221 is_parent 320.
221 is_parent 304.
221 is_parent 314.
221 is_parent 340.
221 is_parent 421.
221 is_parent 425.
221 is_parent 427.

213221 is_parent 404.
213221 is_parent 310.
213221 is_parent 313.
213221 is_parent 317.

310 is_parent 410.

322 is_parent 422.
320 is_parent 420.


% function that takes a course and returns its prereqs

return_prereqs(Course, Prereqs) :-
    findall(Parent, Parent is_parent Course, Prereqs).



% function that takes a course and list of prerequisites and says true if course can be taken
% (note: slightly different from return_prereqs because order should not matter!)

all_prereqs(Course, PrereqsList) :-
    findall(Parent, Parent is_parent Course, Parents),
    subset(Parents, PrereqsList),
    subset(PrereqsList, Parents).

% Helper: subset(L1, L2) checks if L1 is a subset of L2
subset([], _).
subset([Head|Tail], L) :-
    member(Head, L),
    subset(Tail, L).




% function that takes in list of courses taken and suggests next course to take
% (optimize it so that the suggestion satisfies as many future prereqs as possible) -- SOMETHING EXTRA

% is_parent_of(A, B) returns true if A is a parent of B
is_parent_of(P, C) :-
    P is_parent C.

is_sibling_of(A, B) :-
    A \= B,  % Ensure A is not the same as B
    is_parent_of(Parent, A),  % Find a common parent of A
    is_parent_of(Parent, B).  % Find the same common parent for B

is_same_depth_as(A,A) :- true.
is_same_depth_as(A,B) :-
    is_parent_of(X,A),
    is_parent_of(Y,B),
    is_same_depth_as(X,Y).

% is_deeper_than(A, B) checks if A is deeper than B
is_deeper_than(A, B) :-
    is_parent_of(000, B),  % B has no prerequisites
    is_parent_of(X, A),  % Find the parent of A
    000 \= X.

is_deeper_than(A,B) :-
    is_parent_of(X, A), % recurse to one less level of depth
    is_parent_of(Y,B),
    is_deeper_than(X,Y). % returns true if eventually B reaches minimum depth first

% takes in a list of all taken courses, returns all untaken courses that have previously taken courses as prereqs
% IMPORTANT !! THIS DOESNT RETURN ALL POSSIBLE COURSES -- 100 WONT BE IN THE LIST FOR EXAMPLE
find_next_courses(L1, L2) :-
    findall(Prereq, (member(Course, L1), is_parent(Course, Prereq)), NextCourses),
    subtract(NextCourses, L1, L2).