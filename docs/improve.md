# Improve

Leftovers from /improve, so the next run can start here instead of re-auditing. Each line is stamped with the commit it was found at; a run deletes a line once its files have changed or it has acted on it.


- 2026-11-16 | 2e345a2 | mission-executive/asset.rb | Idle sensor action hides a stall - `stalled?` counts a ready sensor action as able to run, so an asset in flight that has to wait for another asset is not stalled while it still owns a sensor action, and the mission carries on; check with two assets of endurance 20, a traverse of 8 on the first, and on the second a traverse of 2, a traverse of 2 that waits on the first asset and a photo action of 15: the waiting traverse completes. Ignoring sensor actions in `stalled?` would also end the mission when an asset has only a sensor action left, so decide that case first.
