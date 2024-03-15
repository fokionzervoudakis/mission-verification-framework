/* SWRL rule */
subject(X) :-
    crosscutting_precondition(_, X, _, _).

/* OWL defined class */
constrained_subject(X) :-
    subject(X),
    is_precondition_to(X, _).

leading_subject(X) :-
    crosscutting_precondition(_, X, _, Y),
    not(sibling_observer(Y)).

/* OWL defined class */
singleton_subject(X) :-
    subject(X),
    singleton(X).

terminal_subject(X) :-
    subject(X),
    terminal(X).

/* SWRL rule */
subject_constraint(Y) :-
    sibling_precondition(_, X, _, Y),
    (
        constrained_subject(X);
        subject_constraint(X)
    ).

/* SWRL rule */
subject_precondition(X) :-
    sibling_precondition(_, X, _, Y),
    (
        subject(Y);
        subject_precondition(Y)
    ).

terminal_subject_constraint(X) :-
    subject_constraint(X),
    terminal(X).
