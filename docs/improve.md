# Improve

Leftovers from /improve, so the next run can start here instead of re-auditing. Each line is stamped with the commit it was found at; a run deletes a line once its files have changed or it has acted on it.


- 2026-11-16 | 0b21445 | mission-executive/asset.rb | Idle sensor action starts an asset - `started?` counts a sensor action with no preconditions as able to run, so an asset whose kinetic actions all wait on another asset spends endurance while waiting and is never `stalled?`; check with two assets of endurance 10, a traverse of 8 on the first, and on the second a traverse of 5 that waits on it plus a photo action of 2: the second traverse is left unfinished. No current plan has this shape, and no model covers it, so ask before changing.
