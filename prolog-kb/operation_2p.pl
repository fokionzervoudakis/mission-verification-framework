:- include(start).

asset(hummingbird_1).
asset(hummingbird_2).
kinetic_action(hover_action_1).
kinetic_action(hover_action_2).
kinetic_action(hover_action_3).
kinetic_action(hover_action_4).
kinetic_action(hover_action_5).
kinetic_action(hover_action_6).
has_action(hummingbird_1, hover_action_1).
has_action(hummingbird_1, hover_action_2).
has_action(hummingbird_1, hover_action_3).
has_action(hummingbird_2, hover_action_4).
has_action(hummingbird_2, hover_action_5).
has_action(hummingbird_2, hover_action_6).
has_precondition(hover_action_2, hover_action_1).
has_precondition(hover_action_2, hover_action_4).
has_precondition(hover_action_3, hover_action_2).
has_precondition(hover_action_3, hover_action_5).
has_precondition(hover_action_5, hover_action_4).
has_precondition(hover_action_6, hover_action_5).

?- print_heading('c1 default').
?- default(hover_action_1). % false
?- default(hover_action_2). % false
?- default(hover_action_3). % false
?- default(hover_action_4). % false
?- default(hover_action_5). % false
?- default(hover_action_6). % false

?- print_heading('c2 default_singleton').
?- default_singleton(hover_action_1). % false
?- default_singleton(hover_action_2). % false
?- default_singleton(hover_action_3). % false
?- default_singleton(hover_action_4). % false
?- default_singleton(hover_action_5). % false
?- default_singleton(hover_action_6). % false

?- print_heading('c3 default_terminal').
?- default_terminal(hover_action_1). % false
?- default_terminal(hover_action_2). % false
?- default_terminal(hover_action_3). % false
?- default_terminal(hover_action_4). % false
?- default_terminal(hover_action_5). % false
?- default_terminal(hover_action_6). % false

?- print_heading('c4 subject_precondition').
?- subject_precondition(hover_action_1). % false
?- subject_precondition(hover_action_2). % false
?- subject_precondition(hover_action_3). % false
?- subject_precondition(hover_action_4).
?- subject_precondition(hover_action_5). % false
?- subject_precondition(hover_action_6). % false

?- print_heading('c5 observer_precondition').
?- observer_precondition(hover_action_1).
?- observer_precondition(hover_action_2).
?- observer_precondition(hover_action_3). % false
?- observer_precondition(hover_action_4). % false
?- observer_precondition(hover_action_5). % false
?- observer_precondition(hover_action_6). % false

?- print_heading('c6 constrained_subject').
?- constrained_subject(hover_action_1). % false
?- constrained_subject(hover_action_2). % false
?- constrained_subject(hover_action_3). % false
?- constrained_subject(hover_action_4).
?- constrained_subject(hover_action_5).
?- constrained_subject(hover_action_6). % false

?- print_heading('c7 leading_subject').
?- leading_subject(hover_action_1). % false
?- leading_subject(hover_action_2). % false
?- leading_subject(hover_action_3). % false
?- leading_subject(hover_action_4). % false
?- leading_subject(hover_action_5). % false
?- leading_subject(hover_action_6). % false

?- print_heading('c8 singleton_subject').
?- singleton_subject(hover_action_1). % false
?- singleton_subject(hover_action_2). % false
?- singleton_subject(hover_action_3). % false
?- singleton_subject(hover_action_4). % false
?- singleton_subject(hover_action_5). % false
?- singleton_subject(hover_action_6). % false

?- print_heading('c9 terminal_subject').
?- terminal_subject(hover_action_1). % false
?- terminal_subject(hover_action_2). % false
?- terminal_subject(hover_action_3). % false
?- terminal_subject(hover_action_4). % false
?- terminal_subject(hover_action_5). % false
?- terminal_subject(hover_action_6). % false

?- print_heading('c10 default_observer').
?- default_observer(hover_action_1). % false
?- default_observer(hover_action_2). % false
?- default_observer(hover_action_3).
?- default_observer(hover_action_4). % false
?- default_observer(hover_action_5). % false
?- default_observer(hover_action_6). % false

?- print_heading('c11 terminal_observer').
?- terminal_observer(hover_action_1). % false
?- terminal_observer(hover_action_2). % false
?- terminal_observer(hover_action_3).
?- terminal_observer(hover_action_4). % false
?- terminal_observer(hover_action_5). % false
?- terminal_observer(hover_action_6). % false

?- print_heading('c12 terminal_constrained_observer').
?- terminal_constrained_observer(hover_action_1). % false
?- terminal_constrained_observer(hover_action_2). % false
?- terminal_constrained_observer(hover_action_3).
?- terminal_constrained_observer(hover_action_4). % false
?- terminal_constrained_observer(hover_action_5). % false
?- terminal_constrained_observer(hover_action_6). % false

?- print_heading('c13 observer_and_constrained_subject').
?- observer_and_constrained_subject(hover_action_1). % false
?- observer_and_constrained_subject(hover_action_2). % false
?- observer_and_constrained_subject(hover_action_3). % false
?- observer_and_constrained_subject(hover_action_4). % false
?- observer_and_constrained_subject(hover_action_5). % false
?- observer_and_constrained_subject(hover_action_6). % false

?- print_heading('c14 observer_and_singleton_subject').
?- observer_and_singleton_subject(hover_action_1). % false
?- observer_and_singleton_subject(hover_action_2). % false
?- observer_and_singleton_subject(hover_action_3). % false
?- observer_and_singleton_subject(hover_action_4). % false
?- observer_and_singleton_subject(hover_action_5). % false
?- observer_and_singleton_subject(hover_action_6). % false

?- print_heading('c15 observer_and_terminal_subject').
?- observer_and_terminal_subject(hover_action_1). % false
?- observer_and_terminal_subject(hover_action_2). % false
?- observer_and_terminal_subject(hover_action_3). % false
?- observer_and_terminal_subject(hover_action_4). % false
?- observer_and_terminal_subject(hover_action_5). % false
?- observer_and_terminal_subject(hover_action_6). % false

?- print_heading('c16 subject_constraint').
?- subject_constraint(hover_action_1). % false
?- subject_constraint(hover_action_2). % false
?- subject_constraint(hover_action_3). % false
?- subject_constraint(hover_action_4). % false
?- subject_constraint(hover_action_5).
?- subject_constraint(hover_action_6).

?- print_heading('c17 terminal_subject_constraint').
?- terminal_subject_constraint(hover_action_1). % false
?- terminal_subject_constraint(hover_action_2). % false
?- terminal_subject_constraint(hover_action_3). % false
?- terminal_subject_constraint(hover_action_4). % false
?- terminal_subject_constraint(hover_action_5). % false
?- terminal_subject_constraint(hover_action_6).

?- print_heading('primary_asset').
?- primary_asset(hummingbird_1).
?- primary_asset(hummingbird_2). % false

:- include(stop).
