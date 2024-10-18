/* SWRL rule */
subject(X) :-
    crosscutting_precondition(_, X, _, _).

% Check with better output
check_constrained_subject(X) :-
    (   constrained_subject(X)
    ->  format('\e[32mSuccess\e[0m: \e[34m~w\e[0m is a \e[33mconstrained subject\e[0m~n', [X])
    ;   format('\e[31mWarning\e[0m: \e[34m~w\e[0m is not a \e[33mconstrained subject\e[0m~n', [X])
    ).

/* OWL defined class */
constrained_subject(X) :-
    subject(X),
    is_precondition_to(X, _).

% Check with better output
check_leading_subject(X) :-
    (   leading_subject(X)
    ->  format('\e[32mSuccess\e[0m: \e[34m~w\e[0m is a \e[33mleading subject\e[0m~n', [X])
    ;   format('\e[31mWarning\e[0m: \e[34m~w\e[0m is not a \e[33mleading subject\e[0m~n', [X])
    ).

leading_subject(X) :-
    crosscutting_precondition(_, X, _, Y),
    not(sibling_observer(Y)).

% Check with better output
check_singleton_subject(X) :-
    (   singleton_subject(X)
    ->  format('\e[32mSuccess\e[0m: \e[34m~w\e[0m is a \e[33msingleton subject\e[0m~n', [X])
    ;   format('\e[31mWarning\e[0m: \e[34m~w\e[0m is not a \e[33msingleton subject\e[0m~n', [X])
    ).

/* OWL defined class */
singleton_subject(X) :-
    subject(X),
    singleton(X).

% Check with better output
check_terminal_subject(X) :-
    (   terminal_subject(X)
    ->  format('\e[32mSuccess\e[0m: \e[34m~w\e[0m is a \e[33mterminal subject\e[0m~n', [X])
    ;   format('\e[31mWarning\e[0m: \e[34m~w\e[0m is not a \e[33mterminal subject\e[0m~n', [X])
    ).

terminal_subject(X) :-
    subject(X),
    terminal(X).

% Check with better output
check_subject_constraint(X) :-
    (   subject_constraint(X)
    ->  format('\e[32mSuccess\e[0m: \e[34m~w\e[0m is a \e[33msubject constraint\e[0m~n', [X])
    ;   format('\e[31mWarning\e[0m: \e[34m~w\e[0m is not a \e[33msubject constraint\e[0m~n', [X])
    ).

/* SWRL rule */
subject_constraint(Y) :-
    sibling_precondition(_, X, _, Y),
    (
        constrained_subject(X);
        subject_constraint(X)
    ).

% Check with better output
check_subject_precondition(X) :-
    (   subject_precondition(X)
    ->  format('\e[32mSuccess\e[0m: \e[34m~w\e[0m is a \e[33msubject precondition\e[0m~n', [X])
    ;   format('\e[31mWarning\e[0m: \e[34m~w\e[0m is not a \e[33msubject precondition\e[0m~n', [X])
    ).

/* SWRL rule */
subject_precondition(X) :-
    sibling_precondition(_, X, _, Y),
    (
        subject(Y);
        subject_precondition(Y)
    ).

% Check with better output
check_terminal_subject_constraint(X) :-
    (   terminal_subject_constraint(X)
    ->  format('\e[32mSuccess\e[0m: \e[34m~w\e[0m is a \e[33mterminal subject constraint\e[0m~n', [X])
    ;   format('\e[31mWarning\e[0m: \e[34m~w\e[0m is not a \e[33mterminal subject constraint\e[0m~n', [X])
    ).

terminal_subject_constraint(X) :-
    subject_constraint(X),
    terminal(X).
