/* OWL defined class */
single_action_asset(A) :-
    bagof(A, X^(has_action(A, X)), C),
    length(C, 1).

/* OWL defined class */
zero_action_asset(A) :-
    not(has_action(A, _)).

/* OWL defined class */
observer_asset(A) :-
    has_action(A, X),
    observer(X).

/* OWL defined class */
observed_asset(A) :-
    has_action(A, X),
    subject(X).

/* SWRL rule */
observes(A, B) :-
    crosscutting_precondition(A, _, B, _).

primary_asset(A) :-
    observer_asset(A),
    (
        not(observed_asset(A));
        (
            observes(A, B),
            observes(B, A)
        )
    ).
