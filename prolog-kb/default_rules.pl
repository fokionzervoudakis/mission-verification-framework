default_util(X) :-
    not(constrained_observer(X)),
    not(observer(X)),
    not(observer_precondition(X)),
    not(subject(X)),
    not(subject_constraint(X)),
    not(subject_precondition(X)).

default(X) :-
    default_util(X),
    not(singleton(X)),
    not(terminal(X)).

default_singleton(X) :-
    default_util(X),
    singleton(X).

default_terminal(X) :-
    default_util(X),
    terminal(X).
