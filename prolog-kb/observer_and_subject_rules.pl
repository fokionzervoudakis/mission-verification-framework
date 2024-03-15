/* OWL defined class */
observer_and_subject(X) :-
    observer(X),
    subject(X).

/* OWL defined class */
observer_and_constrained_subject(X) :-
    observer(X),
    constrained_subject(X).

/* OWL defined class */
observer_and_singleton_subject(X) :-
    observer(X),
    singleton_subject(X).

observer_and_terminal_subject(X) :-
    observer(X),
    terminal_subject(X).
