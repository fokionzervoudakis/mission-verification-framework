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

?- print_heading('c1 default').
?- default(traverse_path_segment_action_1). % false
?- default(traverse_path_segment_action_2). % false
?- default(traverse_path_segment_action_3). % false
?- default(traverse_path_segment_action_4). % false

?- print_heading('c2 default_singleton').
?- default_singleton(traverse_path_segment_action_1). % false
?- default_singleton(traverse_path_segment_action_2). % false
?- default_singleton(traverse_path_segment_action_3). % false
?- default_singleton(traverse_path_segment_action_4). % false

?- print_heading('c3 default_terminal').
?- default_terminal(traverse_path_segment_action_1). % false
?- default_terminal(traverse_path_segment_action_2). % false
?- default_terminal(traverse_path_segment_action_3). % false
?- default_terminal(traverse_path_segment_action_4). % false

?- print_heading('c4 subject_precondition').
?- subject_precondition(traverse_path_segment_action_1). % false
?- subject_precondition(traverse_path_segment_action_2). % false
?- subject_precondition(traverse_path_segment_action_3). % false
?- subject_precondition(traverse_path_segment_action_4). % false

?- print_heading('c5 observer_precondition').
?- observer_precondition(traverse_path_segment_action_1).
?- observer_precondition(traverse_path_segment_action_2). % false
?- observer_precondition(traverse_path_segment_action_3). % false
?- observer_precondition(traverse_path_segment_action_4). % false

?- print_heading('c6 constrained_subject').
?- constrained_subject(traverse_path_segment_action_1). % false
?- constrained_subject(traverse_path_segment_action_2). % false
?- constrained_subject(traverse_path_segment_action_3).
?- constrained_subject(traverse_path_segment_action_4). % false

?- print_heading('c7 leading_subject').
?- leading_subject(traverse_path_segment_action_1). % false
?- leading_subject(traverse_path_segment_action_2). % false
?- leading_subject(traverse_path_segment_action_3). % false
?- leading_subject(traverse_path_segment_action_4). % false

?- print_heading('c8 singleton_subject').
?- singleton_subject(traverse_path_segment_action_1). % false
?- singleton_subject(traverse_path_segment_action_2). % false
?- singleton_subject(traverse_path_segment_action_3). % false
?- singleton_subject(traverse_path_segment_action_4). % false

?- print_heading('c9 terminal_subject').
?- terminal_subject(traverse_path_segment_action_1). % false
?- terminal_subject(traverse_path_segment_action_2). % false
?- terminal_subject(traverse_path_segment_action_3). % false
?- terminal_subject(traverse_path_segment_action_4). % false

?- print_heading('c10 default_observer').
?- default_observer(traverse_path_segment_action_1). % false
?- default_observer(traverse_path_segment_action_2).
?- default_observer(traverse_path_segment_action_3). % false
?- default_observer(traverse_path_segment_action_4). % false

?- print_heading('c11 terminal_observer').
?- terminal_observer(traverse_path_segment_action_1). % false
?- terminal_observer(traverse_path_segment_action_2).
?- terminal_observer(traverse_path_segment_action_3). % false
?- terminal_observer(traverse_path_segment_action_4). % false

?- print_heading('c12 terminal_constrained_observer').
?- terminal_constrained_observer(traverse_path_segment_action_1). % false
?- terminal_constrained_observer(traverse_path_segment_action_2).
?- terminal_constrained_observer(traverse_path_segment_action_3). % false
?- terminal_constrained_observer(traverse_path_segment_action_4). % false

?- print_heading('c13 observer_and_constrained_subject').
?- observer_and_constrained_subject(traverse_path_segment_action_1). % false
?- observer_and_constrained_subject(traverse_path_segment_action_2). % false
?- observer_and_constrained_subject(traverse_path_segment_action_3). % false
?- observer_and_constrained_subject(traverse_path_segment_action_4). % false

?- print_heading('c14 observer_and_singleton_subject').
?- observer_and_singleton_subject(traverse_path_segment_action_1). % false
?- observer_and_singleton_subject(traverse_path_segment_action_2). % false
?- observer_and_singleton_subject(traverse_path_segment_action_3). % false
?- observer_and_singleton_subject(traverse_path_segment_action_4). % false

?- print_heading('c15 observer_and_terminal_subject').
?- observer_and_terminal_subject(traverse_path_segment_action_1). % false
?- observer_and_terminal_subject(traverse_path_segment_action_2). % false
?- observer_and_terminal_subject(traverse_path_segment_action_3). % false
?- observer_and_terminal_subject(traverse_path_segment_action_4). % false

?- print_heading('c16 subject_constraint').
?- subject_constraint(traverse_path_segment_action_1). % false
?- subject_constraint(traverse_path_segment_action_2). % false
?- subject_constraint(traverse_path_segment_action_3). % false
?- subject_constraint(traverse_path_segment_action_4).

?- print_heading('c17 terminal_subject_constraint').
?- terminal_subject_constraint(traverse_path_segment_action_1). % false
?- terminal_subject_constraint(traverse_path_segment_action_2). % false
?- terminal_subject_constraint(traverse_path_segment_action_3). % false
?- terminal_subject_constraint(traverse_path_segment_action_4).

?- print_heading('primary_asset').
?- primary_asset(hummingbird_1).
?- primary_asset(hummingbird_2). % false

:- include(stop).
