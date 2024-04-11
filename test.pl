% To load in Prolog,:
% swipl
% ?- [Prolog_Courses].
  

:- op(500,xfx,'is_parent').


000 is_parent cpsc100.
000 is_parent cpsc103.
000 is_parent cpsc110.
000 is_parent cpsc121.

cpsc103 is_parent cpsc107.
cpsc103 is_parent cpsc203.

cpsc121 is_parent cpsc221. % MAYBE CHANGE THIS CUZ NOT TECHNICALLY TREE

cpsc110 is_parent cpsc302.
cpsc110 is_parent cpsc303.
cpsc110 is_parent cpsc210.
cpsc110 is_parent cpsc221.

cpsc302 is_parent cpsc406.

cpsc210 is_parent cpsc319.
cpsc210 is_parent cpsc311.
cpsc210 is_parent cpsc312.
cpsc210 is_parent cpsc330.

cpsc221 is_parent cpsc213cpsc221.
cpsc221 is_parent cpsc322.
cpsc221 is_parent cpsc320.
cpsc221 is_parent cpsc304.
cpsc221 is_parent cpsc314.
cpsc221 is_parent cpsc340.
cpsc221 is_parent cpsc421.
cpsc221 is_parent cpsc425.
cpsc221 is_parent cpsc427.

cpsc213cpsc221 is_parent cpsc404.
cpsc213cpsc221 is_parent cpsc310.
cpsc213cpsc221 is_parent cpsc313.
cpsc213cpsc221 is_parent cpsc317.

cpsc310 is_parent cpsc410.

cpsc322 is_parent cpsc422.
cpsc320 is_parent cpsc420.


% --------------------------------- SETUP CODE -----------------------------------------






% return_prereqs takes a course and returns its prereqs
return_prereqs(Course, Prereqs) :-
    findall(Parent, Parent is_parent Course, Prereqs).



% all_prereqs takes a course and list of prerequisites and says true if course can be taken
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






% is_parent_of(A, B) returns true if A is a parent of B
is_parent_of(P, C) :-
    P is_parent C.

is_sibling_of(A, B) :-
    A \= B,  % Ensure A is not the same as B
    is_parent_of(Parent, A),  % Find a common parent of A
    is_parent_of(Parent, B).  % Find the same common parent for B


% Calculate how deep a course is (1 is a course with no prereqs)
depth_of_course(Course, Depth) :-
    depth_of_course_helper(Course, 0, Depth).

depth_of_course_helper(Course, Acc, Depth) :-
    is_parent_of(Parent, Course),
    NewAcc is Acc + 1,
    depth_of_course_helper(Parent, NewAcc, Depth).
depth_of_course_helper(Course, Depth, Depth).


is_same_depth_as(A,B) :- 
    is_sibling_of(A,B).
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



% find_next_courses takes a list of all taken courses, returns all untaken courses that have previously taken courses as prereqs
% IMPORTANT !! THIS DOESNT RETURN ALL POSSIBLE COURSES -- cpsc100 WONT BE IN THE LIST FOR EXAMPLE
find_next_courses(L1, L2) :-
    findall(Prereq, (member(Course, L1), is_parent(Course, Prereq)), NextCourses),
    subtract(NextCourses, L1, L2).

% recommend_most_advanced_courses takes a list of previously taken courses, and returns a list of
% (or just one) course that has/have the greatest depth out of them
