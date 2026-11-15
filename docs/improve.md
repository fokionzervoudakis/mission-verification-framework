# Improve

Leftovers from /improve, so the next run can start here instead of re-auditing. Each line is stamped with the commit it was found at; a run deletes a line once its files have changed or it has acted on it.


- 2026-11-15 | 730736f | mission-executive/test/model_test.rb CLAUDE.md | No test pins the primary asset - every model's shared step (`asst<N>`) is currently named after a `primary_asset` in its classification file, but nothing checks it; compare `grep -o 'asst[0-9]*' models/*/<op>.pm` with the classification's primary assets.
- 2026-11-15 | 730736f | mission-executive/test/model_test.rb CLAUDE.md | No test pins "point of failure" comments - all 19 marked plans have one such comment in both the plan and its model today, unchecked; compare `grep -c 'point of failure'` on each `.yaml` and `.pm`.
- 2026-11-15 | fbd07a0 | parser/metrics.rb data/mission-metrics.csv | metrics CSV has no trailing newline - `metrics.rb` writes `lines.join("\n")` with no final newline, unlike `model_results.rb`; check with `tail -c 1 data/mission-metrics.csv | xxd`.
