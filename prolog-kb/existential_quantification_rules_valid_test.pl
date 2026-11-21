:- include(existential_quantification_rules).

asset(ardrone_1).
kinetic_action(hover_action_1).
kinetic_action(traverse_action_1).
lidar_action(lidar_action_1).
mission(mission_1).
photo_surveillance_action(photo_surveillance_action_1).

has_action(ardrone_1, hover_action_1).
has_asset(mission_1, ardrone_1).
has_duration_in_seconds(hover_action_1, 10).
has_duration_in_seconds(photo_surveillance_action_1, 10).
has_duration_in_seconds(traverse_action_1, 10).
has_endpoint(traverse_action_1, waypoint_2).
has_endurance_in_seconds(ardrone_1, 120).
has_interval_in_seconds(lidar_action_1, 1).
has_start_point(traverse_action_1, waypoint_1).
has_waypoint(hover_action_1, waypoint_1).
is_concurrent_with(lidar_action_1, hover_action_1).

?- not(invalid_kinetic_action(hover_action_1)).
?- not(invalid_hover_action(hover_action_1)).
?- not(invalid_traverse_path_segmentAction(traverse_action_1)).
?- not(invalid_photo_surveillance_action(photo_surveillance_action_1)).
?- not(invalid_asset(ardrone_1)).
?- not(invalid_mission(mission_1)).
?- not(invalid_lidar_action(lidar_action_1)).
