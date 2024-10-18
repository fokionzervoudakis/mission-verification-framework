:- include(start).

asset(hummingbird_1).
asset(hummingbird_2).
kinetic_action(traverse_path_segment_action_1).
kinetic_action(traverse_path_segment_action_2).
kinetic_action(traverse_path_segment_action_3).
kinetic_action(traverse_path_segment_action_4).
has_action(hummingbird_1, traverse_path_segment_action_1).
has_action(hummingbird_1, traverse_path_segment_action_2).
has_action(hummingbird_2, traverse_path_segment_action_3).
has_action(hummingbird_2, traverse_path_segment_action_4).
has_precondition(traverse_path_segment_action_2, traverse_path_segment_action_1).
has_precondition(traverse_path_segment_action_2, traverse_path_segment_action_3).
has_precondition(traverse_path_segment_action_4, traverse_path_segment_action_3).

?- print_heading('operation_A').

?- nl.
?- check_default(traverse_path_segment_action_1). % false
?- check_default(traverse_path_segment_action_2). % false
?- check_default(traverse_path_segment_action_3). % false
?- check_default(traverse_path_segment_action_4). % false

?- nl.
?- check_default_singleton(traverse_path_segment_action_1). % false
?- check_default_singleton(traverse_path_segment_action_2). % false
?- check_default_singleton(traverse_path_segment_action_3). % false
?- check_default_singleton(traverse_path_segment_action_4). % false

?- nl.
?- check_default_terminal(traverse_path_segment_action_1). % false
?- check_default_terminal(traverse_path_segment_action_2). % false
?- check_default_terminal(traverse_path_segment_action_3). % false
?- check_default_terminal(traverse_path_segment_action_4). % false

?- nl.
?- check_subject_precondition(traverse_path_segment_action_1). % false
?- check_subject_precondition(traverse_path_segment_action_2). % false
?- check_subject_precondition(traverse_path_segment_action_3). % false
?- check_subject_precondition(traverse_path_segment_action_4). % false

?- nl.
?- check_observer_precondition(traverse_path_segment_action_1).
?- check_observer_precondition(traverse_path_segment_action_2). % false
?- check_observer_precondition(traverse_path_segment_action_3). % false
?- check_observer_precondition(traverse_path_segment_action_4). % false

?- nl.
?- check_constrained_subject(traverse_path_segment_action_1). % false
?- check_constrained_subject(traverse_path_segment_action_2). % false
?- check_constrained_subject(traverse_path_segment_action_3).
?- check_constrained_subject(traverse_path_segment_action_4). % false

?- nl.
?- check_leading_subject(traverse_path_segment_action_1). % false
?- check_leading_subject(traverse_path_segment_action_2). % false
?- check_leading_subject(traverse_path_segment_action_3). % false
?- check_leading_subject(traverse_path_segment_action_4). % false

?- nl.
?- check_singleton_subject(traverse_path_segment_action_1). % false
?- check_singleton_subject(traverse_path_segment_action_2). % false
?- check_singleton_subject(traverse_path_segment_action_3). % false
?- check_singleton_subject(traverse_path_segment_action_4). % false

?- nl.
?- check_terminal_subject(traverse_path_segment_action_1). % false
?- check_terminal_subject(traverse_path_segment_action_2). % false
?- check_terminal_subject(traverse_path_segment_action_3). % false
?- check_terminal_subject(traverse_path_segment_action_4). % false

?- nl.
?- check_default_observer(traverse_path_segment_action_1). % false
?- check_default_observer(traverse_path_segment_action_2).
?- check_default_observer(traverse_path_segment_action_3). % false
?- check_default_observer(traverse_path_segment_action_4). % false

?- nl.
?- check_terminal_observer(traverse_path_segment_action_1). % false
?- check_terminal_observer(traverse_path_segment_action_2).
?- check_terminal_observer(traverse_path_segment_action_3). % false
?- check_terminal_observer(traverse_path_segment_action_4). % false

?- nl.
?- check_terminal_constrained_observer(traverse_path_segment_action_1). % false
?- check_terminal_constrained_observer(traverse_path_segment_action_2).
?- check_terminal_constrained_observer(traverse_path_segment_action_3). % false
?- check_terminal_constrained_observer(traverse_path_segment_action_4). % false

?- nl.
?- check_observer_and_constrained_subject(traverse_path_segment_action_1). % false
?- check_observer_and_constrained_subject(traverse_path_segment_action_2). % false
?- check_observer_and_constrained_subject(traverse_path_segment_action_3). % false
?- check_observer_and_constrained_subject(traverse_path_segment_action_4). % false

?- nl.
?- check_observer_and_singleton_subject(traverse_path_segment_action_1). % false
?- check_observer_and_singleton_subject(traverse_path_segment_action_2). % false
?- check_observer_and_singleton_subject(traverse_path_segment_action_3). % false
?- check_observer_and_singleton_subject(traverse_path_segment_action_4). % false

?- nl.
?- check_observer_and_terminal_subject(traverse_path_segment_action_1). % false
?- check_observer_and_terminal_subject(traverse_path_segment_action_2). % false
?- check_observer_and_terminal_subject(traverse_path_segment_action_3). % false
?- check_observer_and_terminal_subject(traverse_path_segment_action_4). % false

?- nl.
?- check_subject_constraint(traverse_path_segment_action_1). % false
?- check_subject_constraint(traverse_path_segment_action_2). % false
?- check_subject_constraint(traverse_path_segment_action_3). % false
?- check_subject_constraint(traverse_path_segment_action_4).

?- nl.
?- check_terminal_subject_constraint(traverse_path_segment_action_1). % false
?- check_terminal_subject_constraint(traverse_path_segment_action_2). % false
?- check_terminal_subject_constraint(traverse_path_segment_action_3). % false
?- check_terminal_subject_constraint(traverse_path_segment_action_4).

?- nl.
?- check_primary_asset(hummingbird_1).
?- check_primary_asset(hummingbird_2). % false

:- include(stop).
