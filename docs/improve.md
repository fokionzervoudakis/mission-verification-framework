# Improve

Leftovers from /improve, so the next run can start here instead of re-auditing. Each line is stamped with the commit it was found at; a run deletes a line once its files have changed or it has acted on it.

- 2026-11-16 | aa6253a | mission-executive/test/model_test.rb CLAUDE.md | No test pins action guards - in every model the command that counts an action down waits on exactly the plan's preconditions (`dN=0`) and on its owner's endurance (`eN>0`), but nothing checks it; the one idiom to allow for is action 4 of operation_2g, 2h and 2i, which waits on leading action 1 through the shared step instead of a `d1=0` guard. Check by scanning each `(dN'=dN-1)` command, with renamed modules written out as `template_test.rb` does.
- 2026-11-16 | aa6253a | mission-executive/test/model_test.rb CLAUDE.md | No test pins "point of failure" comments - all 19 marked plans have one such comment on the same action in both the plan and its model today, unchecked; compare `grep -c 'point of failure'` on each `.yaml` and `.pm`.
