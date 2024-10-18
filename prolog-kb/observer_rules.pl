/* SWRL rule */
observer(Y) :-
    crosscutting_precondition(_, _, _, Y).

% Check with better output
check_default_observer(X) :-
    (
        default_observer(X)
    ->  format('\e[32mSuccess\e[0m: \e[34m~w\e[0m is a \e[33mdefault observer\e[0m~n', [X])
    ;   format('\e[31mWarning\e[0m: \e[34m~w\e[0m is not a \e[33mdefault observer\e[0m~n', [X])
    ).

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

% Check with better output
check_terminal_observer(X) :-
    (
        terminal_observer(X)
    ->  format('\e[32mSuccess\e[0m: \e[34m~w\e[0m is a \e[33mterminal observer\e[0m~n', [X])
    ;   format('\e[31mWarning\e[0m: \e[34m~w\e[0m is not a \e[33mterminal observer\e[0m~n', [X])
    ).

terminal_observer(X) :-
    observer(X),
    terminal(X).

% Check with better output
check_terminal_constrained_observer(X) :-
    (
        terminal_constrained_observer(X)
    ->  format('\e[32mSuccess\e[0m: \e[34m~w\e[0m is a \e[33mterminal constrained observer\e[0m~n', [X])
    ;   format('\e[31mWarning\e[0m: \e[34m~w\e[0m is not a \e[33mterminal constrained observer\e[0m~n', [X])
    ).

terminal_constrained_observer(X) :-
    constrained_observer(X),
    terminal(X).

% Check with better output
check_observer_precondition(X) :-
    (
        observer_precondition(X)
    ->  format('\e[32mSuccess\e[0m: \e[34m~w\e[0m is an \e[33mobserver precondition\e[0m~n', [X])
    ;   format('\e[31mWarning\e[0m: \e[34m~w\e[0m is not an \e[33mobserver precondition\e[0m~n', [X])
    ).

/* SWRL rule */
observer_precondition(X) :-
    sibling_precondition(_, X, _, Y),
    (
        observer(Y);
        observer_precondition(Y)
    ).
