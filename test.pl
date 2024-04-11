% To load in Prolog,:
% swipl
% ?- [test].
  

:- op(500,xfx,'is_parent').

cpscRoot is_parent cpsc100.
cpscRoot is_parent cpsc103.
cpscRoot is_parent cpsc110.
cpscRoot is_parent cpsc121.

cpsc103 is_parent cpsc107.
cpsc103 is_parent cpsc203.

cpsc121 is_parent cpsc221.
cpsc121 is_parent cpsc213.

cpsc110 is_parent cpsc302.
cpsc110 is_parent cpsc303.
cpsc110 is_parent cpsc210.
cpsc110 is_parent cpsc221.
cpsc110 is_parent cpsc213.

cpsc302 is_parent cpsc406.

cpsc210 is_parent cpsc319.
cpsc210 is_parent cpsc311.
cpsc210 is_parent cpsc312.
cpsc210 is_parent cpsc330.
cpsc210 is_parent cpsc213.

cpsc221 is_parent cpsc322.
cpsc221 is_parent cpsc320.
cpsc221 is_parent cpsc304.
cpsc221 is_parent cpsc314.
cpsc221 is_parent cpsc340.
cpsc221 is_parent cpsc421.
cpsc221 is_parent cpsc425.
cpsc221 is_parent cpsc427.
cpsc221 is_parent cpsc404.
cpsc221 is_parent cpsc310.
cpsc221 is_parent cpsc313.
cpsc221 is_parent cpsc317.
cpsc221 is_parent cpsc411.

cpsc213 is_parent cpsc404.
cpsc213 is_parent cpsc310.
cpsc213 is_parent cpsc313.
cpsc213 is_parent cpsc317.
cpsc213 is_parent cpsc411.

cpsc310 is_parent cpsc410.
cpsc310 is_parent cpsc447.
cpsc322 is_parent cpsc422.
cpsc320 is_parent cpsc420.
cpsc340 is_parent cpsc440.
cpsc302 is_parent cpsc402. 
cpsc304 is_parent cpsc404.
cpsc302 is_parent cpsc406.
cpsc311 is_parent cpsc411.
cpsc313 is_parent cpsc415.
cpsc313 is_parent cpsc416.
cpsc317 is_parent cpsc416.
cpsc313 is_parent cpsc417.
cpsc317 is_parent cpsc417.
cpsc320 is_parent cpsc418.
cpsc320 is_parent cpsc424.
cpsc314 is_parent cpsc426.
cpsc344 is_parent cpsc444.

mathRoot is_parent math100.
mathRoot is_parent math120.

math100 is_parent math101.
math100 is_parent math221.
math101 is_parent math200.
math200 is_parent math300.
math200 is_parent math317.
math200 is_parent math215.
math215 is_parent math316.

math120 is_parent math121.
math121 is_parent math226.
math121 is_parent math223.
math226 is_parent math227.
math227 is_parent math424.
math223 is_parent math424.
math424 is_parent math425.
math226 is_parent math320.
math320 is_parent math321.
math321 is_parent math420.
math420 is_parent math421.
math300 is_parent math440.
math300 is_parent math404.
math420 is_parent math404.
math320 is_parent math440.
math321 is_parent math418.
math420 is_parent math419.
math223 is_parent math322.
math322 is_parent math323.
math321 is_parent math426.
math322 is_parent math426.
math426 is_parent math427.
math323 is_parent math422.
math424 is_parent math423.
math322 is_parent math412.
math320 is_parent math412.



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
    depth_of_course_helper(Course, 0, Depth),
    !.

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
% base case
is_deeper_than(A, B) :-
    is_parent_of(cpscRoot, B),  % B has no prerequisites
    is_parent_of(X, A),  % Find the parent of A
    cpscRoot \= X.
% recursive case
is_deeper_than(A,B) :-
    is_parent_of(X, A), % recurse to one less level of depth
    is_parent_of(Y,B),
    is_deeper_than(X,Y). % returns true if eventually B reaches minimum depth first

% Define the predicate to map courses to their depths
map_courses_to_depths([], []).
map_courses_to_depths([Course|Rest], [Depth|Depths]) :-
    depth_of_course(Course, Depth),
    map_courses_to_depths(Rest, Depths).

% Define the predicate to return courses with maximum depth
courses_with_max_depth(Courses, MaxDepthCourses) :-
    % Map courses to their depths
    map_courses_to_depths(Courses, Depths),
    % Find the maximum depth
    max_list(Depths, MaxDepth),
    % Filter the courses with maximum depth
    filter_courses_with_max_depth(Courses, Depths, MaxDepth, MaxDepthCourses),
    !.

% Helper predicate to filter courses with maximum depth
filter_courses_with_max_depth([], [], _, []).
filter_courses_with_max_depth([Course|RestCourses], [Depth|RestDepths], MaxDepth, [Course|MaxDepthCourses]) :-
    Depth == MaxDepth,
    filter_courses_with_max_depth(RestCourses, RestDepths, MaxDepth, MaxDepthCourses).
filter_courses_with_max_depth([_|RestCourses], [_|RestDepths], MaxDepth, MaxDepthCourses) :-
    filter_courses_with_max_depth(RestCourses, RestDepths, MaxDepth, MaxDepthCourses).

% find_next_courses takes a list of all taken courses, returns all untaken courses that have previously taken courses as prereqs
% IMPORTANT !! THIS DOESNT RETURN ALL POSSIBLE COURSES -- cpsc100 WONT BE IN THE LIST FOR EXAMPLE
find_next_courses(L1, L2) :-
    findall(Prereq, (member(Course, L1), is_parent(Course, Prereq)), NextCourses),
    subtract(NextCourses, L1, Temp),
    list_to_set(Temp,L2).

% recommend_most_advanced_courses takes a list of previously taken courses, and returns a list of
% (or just one) course that has/have the greatest depth out of them
recommend_most_advanced_courses(L1,L2) :-
    find_next_courses(L1, NextCourses),
    courses_with_max_depth(NextCourses, L2).

