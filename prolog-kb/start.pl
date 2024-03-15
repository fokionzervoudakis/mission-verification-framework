:- include(asset_rules).
    :- multifile single_action_asset/1.
    :- multifile zero_action_asset/1.
    :- multifile observer_asset/1.
    :- multifile observed_asset/1.
    :- multifile observes/2.
    :- multifile primary_asset/1.

:- include(default_rules).
    :- multifile default_util/1.
    :- multifile default/1.
    :- multifile default_singleton/1.
    :- multifile default_terminal/1.

:- include(formatting_rules).
    :- multifile print_heading/1.

:- include(observer_and_subject_rules).
    :- multifile observer_and_subject/1.
    :- multifile observer_and_constrained_subject/1.
    :- multifile observer_and_singleton_subject/1.
    :- multifile observer_and_terminal_subject/1.

:- include(observer_rules).
    :- multifile observer/1.
    :- multifile default_observer/1.
    :- multifile constrained_observer/1.
    :- multifile sibling_observer/1.
    :- multifile terminal_observer/1.
    :- multifile terminal_constrained_observer/1.
    :- multifile observer_precondition/1.

:- include(subject_rules).
    :- multifile subject/1.
    :- multifile constrained_subject/1.
    :- multifile leading_subject/1.
    :- multifile singleton_subject/1.
    :- multifile terminal_subject/1.
    :- multifile subject_constraint/1.
    :- multifile subject_precondition/1.
    :- multifile terminal_subject_constraint/1.

:- include(utility_rules).
    :- multifile precondition_util/4.
    :- multifile crosscutting_precondition/4.
    :- multifile sibling_precondition/4.
    :- multifile is_precondition_to/2.
    :- multifile singleton/1.
    :- multifile terminal/1.
