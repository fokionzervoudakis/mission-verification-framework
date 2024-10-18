:- include(start).

asset(ardrone_1).
asset(hummingbird_1).
asset(hummingbird_2).
kinetic_action(hover_action_1).
kinetic_action(hover_action_2).
kinetic_action(hover_action_3).
kinetic_action(hover_action_4).
has_action(ardrone_1, hover_action_1).
has_action(ardrone_1, hover_action_2).
has_action(hummingbird_1, hover_action_3).
has_action(hummingbird_2, hover_action_4).
has_precondition(hover_action_2, hover_action_1).
has_precondition(hover_action_2, hover_action_3).
has_precondition(hover_action_2, hover_action_4).

?- print_heading('operation_2e').

?- nl.
?- check_default(hover_action_1). % false
?- check_default(hover_action_2). % false
?- check_default(hover_action_3). % false
?- check_default(hover_action_4). % false

?- nl.
?- check_default_singleton(hover_action_1). % false
?- check_default_singleton(hover_action_2). % false
?- check_default_singleton(hover_action_3). % false
?- check_default_singleton(hover_action_4). % false

?- nl.
?- check_default_terminal(hover_action_1). % false
?- check_default_terminal(hover_action_2). % false
?- check_default_terminal(hover_action_3). % false
?- check_default_terminal(hover_action_4). % false

?- nl.
?- check_subject_precondition(hover_action_1). % false
?- check_subject_precondition(hover_action_2). % false
?- check_subject_precondition(hover_action_3). % false
?- check_subject_precondition(hover_action_4). % false

?- nl.
?- check_observer_precondition(hover_action_1).
?- check_observer_precondition(hover_action_2). % false
?- check_observer_precondition(hover_action_3). % false
?- check_observer_precondition(hover_action_4). % false

?- nl.
?- check_constrained_subject(hover_action_1). % false
?- check_constrained_subject(hover_action_2). % false
?- check_constrained_subject(hover_action_3). % false
?- check_constrained_subject(hover_action_4). % false

?- nl.
?- check_leading_subject(hover_action_1). % false
?- check_leading_subject(hover_action_2). % false
?- check_leading_subject(hover_action_3). % false
?- check_leading_subject(hover_action_4). % false

?- nl.
?- check_singleton_subject(hover_action_1). % false
?- check_singleton_subject(hover_action_2). % false
?- check_singleton_subject(hover_action_3).
?- check_singleton_subject(hover_action_4).

?- nl.
?- check_terminal_subject(hover_action_1). % false
?- check_terminal_subject(hover_action_2). % false
?- check_terminal_subject(hover_action_3). % false
?- check_terminal_subject(hover_action_4). % false

?- nl.
?- check_default_observer(hover_action_1). % false
?- check_default_observer(hover_action_2).
?- check_default_observer(hover_action_3). % false
?- check_default_observer(hover_action_4). % false

?- nl.
?- check_terminal_observer(hover_action_1). % false
?- check_terminal_observer(hover_action_2).
?- check_terminal_observer(hover_action_3). % false
?- check_terminal_observer(hover_action_4). % false

?- nl.
?- check_terminal_constrained_observer(hover_action_1). % false
?- check_terminal_constrained_observer(hover_action_2). % false
?- check_terminal_constrained_observer(hover_action_3). % false
?- check_terminal_constrained_observer(hover_action_4). % false

?- nl.
?- check_observer_and_constrained_subject(hover_action_1). % false
?- check_observer_and_constrained_subject(hover_action_2). % false
?- check_observer_and_constrained_subject(hover_action_3). % false
?- check_observer_and_constrained_subject(hover_action_4). % false

?- nl.
?- check_observer_and_singleton_subject(hover_action_1). % false
?- check_observer_and_singleton_subject(hover_action_2). % false
?- check_observer_and_singleton_subject(hover_action_3). % false
?- check_observer_and_singleton_subject(hover_action_4). % false

?- nl.
?- check_observer_and_terminal_subject(hover_action_1). % false
?- check_observer_and_terminal_subject(hover_action_2). % false
?- check_observer_and_terminal_subject(hover_action_3). % false
?- check_observer_and_terminal_subject(hover_action_4). % false

?- nl.
?- check_subject_constraint(hover_action_1). % false
?- check_subject_constraint(hover_action_2). % false
?- check_subject_constraint(hover_action_3). % false
?- check_subject_constraint(hover_action_4). % false

?- nl.
?- check_terminal_subject_constraint(hover_action_1). % false
?- check_terminal_subject_constraint(hover_action_2). % false
?- check_terminal_subject_constraint(hover_action_3). % false
?- check_terminal_subject_constraint(hover_action_4). % false

?- nl.
?- check_primary_asset(ardrone_1).
?- check_primary_asset(hummingbird_1). % false
?- check_primary_asset(hummingbird_2). % false

:- include(stop).
