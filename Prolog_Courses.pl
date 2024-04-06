% CPSC 312 2024
% Some simple Prolog examples. In public domain.

% To load in Prolog,:
% swipl
% ?- [trees].
  

:- op(500,xfx,'is_parent').


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