# Improve

Leftovers from /improve, so the next run can start here instead of re-auditing. Each line is stamped with the commit it was found at; a run deletes a line once its files have changed or it has acted on it.

- 2026-11-12 | 44eab50 | mission-executive/asset.rb mission-executive/mission.rb | Delete-during-each skips the next element - Asset#execute and Mission.execute remove completed items from the array they are iterating, so the following action/asset sits out that timestep (and still burns endurance); check with two independent duration-1 actions on one asset, which take 2 ticks instead of 1.
- 2026-11-12 | 44eab50 | mission-executive/asset.rb mission-executive/lidar_action.rb | LidarAction has no completed? - Asset#execute calls action.completed?, which LidarAction (operation_5a/5b) does not define; check whether an asset in those ops lists a lidar action and runs it through Asset#execute.
- 2026-11-12 | 44eab50 | justfile mission-executive | No tests - the simulator (subject/observer, asset scheduling) has no test suite or test recipe; the notify bug above went unnoticed because just execute only prints "executing ...".
