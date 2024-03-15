:- dynamic asset/1.
:- dynamic kinetic_action/1.
:- dynamic has_action/2.
:- dynamic has_precondition/2.

precondition_util(A, X, B, Y) :-
    has_action(A, X),
    has_action(B, Y),
    has_precondition(Y, X).

crosscutting_precondition(A, X, B, Y) :-
    precondition_util(A, X, B, Y),
    not(A = B).

sibling_precondition(A, X, B, Y) :-
    precondition_util(A, X, B, Y),
    A = B.

/* OWL property */
is_precondition_to(X, Y) :-
    has_action(A, X),
    has_action(A, Y),
    has_precondition(Y, X).

/* OWL defined class */
singleton(X) :-
    has_action(A, X),
    single_action_asset(A).

terminal(X) :-
    has_action(A, X),
    not(is_precondition_to(X, _)),
    not(single_action_asset(A)),
    not(zero_action_asset(A)).
