/* SWRL rule */
observer(Y) :-
    crosscutting_precondition(_, _, _, Y).

default_observer(X) :-
    observer(X),
    not(observer_precondition(X)).

/* SWRL rule */
constrained_observer(Y) :-
    constrained_subject(X),
    crosscutting_precondition(_, X, _, Y).

/* SWRL rule */
sibling_observer(Y) :-
    sibling_precondition(_, _, _, Y).

terminal_observer(X) :-
    observer(X),
    terminal(X).

terminal_constrained_observer(X) :-
    constrained_observer(X),
    terminal(X).

/* SWRL rule */
observer_precondition(X) :-
    sibling_precondition(_, X, _, Y),
    (
        observer(Y);
        observer_precondition(Y)
    ).
