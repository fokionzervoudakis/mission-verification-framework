/* OWL defined class */
observer_and_subject(X) :-
    observer(X),
    subject(X).

% Check with better output
check_observer_and_constrained_subject(X) :-
    (   observer_and_constrained_subject(X)
    ->  format('\e[32mSuccess\e[0m: \e[34m~w\e[0m is an \e[33mobserver and constrained subject\e[0m~n', [X])
    ;   format('\e[31mWarning\e[0m: \e[34m~w\e[0m is not an \e[33mobserver and constrained subject\e[0m~n', [X])
    ).

/* OWL defined class */
observer_and_constrained_subject(X) :-
    observer(X),
    constrained_subject(X).

% Check with better output
check_observer_and_singleton_subject(X) :-
    (   observer_and_singleton_subject(X)
    ->  format('\e[32mSuccess\e[0m: \e[34m~w\e[0m is an \e[33mobserver and singleton subject\e[0m~n', [X])
    ;   format('\e[31mWarning\e[0m: \e[34m~w\e[0m is not an \e[33mobserver and singleton subject\e[0m~n', [X])
    ).

/* OWL defined class */
observer_and_singleton_subject(X) :-
    observer(X),
    singleton_subject(X).

% Check with better output
check_observer_and_terminal_subject(X) :-
    (   observer_and_terminal_subject(X)
    ->  format('\e[32mSuccess\e[0m: \e[34m~w\e[0m is an \e[33mobserver and terminal subject\e[0m~n', [X])
    ;   format('\e[31mWarning\e[0m: \e[34m~w\e[0m is not an \e[33mobserver and terminal subject\e[0m~n', [X])
    ).

observer_and_terminal_subject(X) :-
    observer(X),
    terminal_subject(X).
