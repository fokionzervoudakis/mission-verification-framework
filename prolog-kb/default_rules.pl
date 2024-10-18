default_util(X) :-
    not(constrained_observer(X)),
    not(observer(X)),
    not(observer_precondition(X)),
    not(subject(X)),
    not(subject_constraint(X)),
    not(subject_precondition(X)).

% Check with better output
check_default(X) :-
    (   default(X)
    ->  format('\e[32mSuccess\e[0m: \e[34m~w\e[0m is a \e[33mdefault\e[0m~n', [X])
    ;   format('\e[31mWarning\e[0m: \e[34m~w\e[0m is not a \e[33mdefault\e[0m~n', [X])
    ).

default(X) :-
    default_util(X),
    not(singleton(X)),
    not(terminal(X)).

% Check with better output
check_default_singleton(X) :-
    (   default_singleton(X)
    ->  format('\e[32mSuccess\e[0m: \e[34m~w\e[0m is a \e[33mdefault singleton\e[0m~n', [X])
    ;   format('\e[31mWarning\e[0m: \e[34m~w\e[0m is not a \e[33mdefault singleton\e[0m~n', [X])
    ).

default_singleton(X) :-
    default_util(X),
    singleton(X).

% Check with better output
check_default_terminal(X) :-
    (   default_terminal(X)
    ->  format('\e[32mSuccess\e[0m: \e[34m~w\e[0m is a \e[33mdefault terminal\e[0m~n', [X])
    ;   format('\e[31mWarning\e[0m: \e[34m~w\e[0m is not a \e[33mdefault terminal\e[0m~n', [X])
    ).

default_terminal(X) :-
    default_util(X),
    terminal(X).
