:- include(start).

asset(ardrone_1).
kinetic_action(hover_action_1).
has_action(ardrone_1, hover_action_1).

?- print_heading('operation_1a').

?- nl.
?- check_default(hover_action_1). % false

?- nl.
?- check_default_singleton(hover_action_1).

?- nl.
?- check_default_terminal(hover_action_1). % false

?- nl.
?- check_subject_precondition(hover_action_1). % false

?- nl.
?- check_observer_precondition(hover_action_1). % false

?- nl.
?- check_constrained_subject(hover_action_1). % false

?- nl.
?- check_leading_subject(hover_action_1). % false

?- nl.
?- check_singleton_subject(hover_action_1). % false

?- nl.
?- check_terminal_subject(hover_action_1). % false

?- nl.
?- check_default_observer(hover_action_1). % false

?- nl.
?- check_terminal_observer(hover_action_1). % false

?- nl.
?- check_terminal_constrained_observer(hover_action_1). % false

?- nl.
?- check_observer_and_constrained_subject(hover_action_1). % false

?- nl.
?- check_observer_and_singleton_subject(hover_action_1). % false

?- nl.
?- check_observer_and_terminal_subject(hover_action_1). % false

?- nl.
?- check_subject_constraint(hover_action_1). % false

?- nl.
?- check_terminal_subject_constraint(hover_action_1). % false

?- nl.
?- check_primary_asset(ardrone_1). % false

:- include(stop).
