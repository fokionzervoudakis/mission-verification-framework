:- include(existential_quantification_rules).

asset(ardrone_1).
kinetic_action(hover_action_1).
lidar_action(lidar_action_1).
mission(mission_1).
photo_surveillance_action(photo_surveillance_action_1).

?- not(invalid_kinetic_action(hover_action_1)). % false
?- not(invalid_hover_action(hover_action_1)). % false
?- not(invalid_traverse_path_segmentAction(hover_action_1)). % false
?- not(invalid_photo_surveillance_action(photo_surveillance_action_1)). % false
?- not(invalid_asset(ardrone_1)). % false
?- not(invalid_mission(mission_1)). % false
?- not(invalid_lidar_action(lidar_action_1)). % false
