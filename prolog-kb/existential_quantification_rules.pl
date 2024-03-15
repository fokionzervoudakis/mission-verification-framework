:- include(asset_rules).
:- include(utility_rules).

:- dynamic has_asset/2.
:- dynamic has_duration_in_seconds/2.
:- dynamic has_endpoint/2.
:- dynamic has_endurance_in_seconds/2.
:- dynamic has_interval_in_seconds/2.
:- dynamic has_start_point/2.
:- dynamic has_waypoint/2.
:- dynamic is_concurrent_with/2.
:- dynamic lidar_action/1.
:- dynamic mission/1.
:- dynamic photo_surveillance_action/1.

invalid_kinetic_action(K) :-
    not(has_duration_in_seconds(K, _)).

invalid_hover_action(H) :-
    invalid_kinetic_action(H);
    not(has_waypoint(H, _)).

invalid_traverse_path_segmentAction(T) :-
    invalid_kinetic_action(T);
    not(has_endpoint(T, _));
    not(has_start_point(T, _)).

invalid_photo_surveillance_action(P) :-
    not(has_duration_in_seconds(P, _)).

invalid_asset(A) :-
    zero_action_asset(A);
    not(has_endurance_in_seconds(A, _)).

invalid_mission(M) :-
    not(has_asset(M, _)).

invalid_lidar_action(L) :-
    not(has_interval_in_seconds(L, _));
    not(is_concurrent_with(L, _)).
