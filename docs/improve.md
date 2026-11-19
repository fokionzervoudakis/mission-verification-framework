# Improve

Leftovers from /improve, so the next run can start here instead of re-auditing. Each line is stamped with the commit it was found at; a run deletes a line once its files have changed or it has acted on it.

- 2026-11-19 | f061c32 | mission-executive/test/plan_test.rb ontology/complex_tactical_missions.owl ontology/complex_traffic_surveillance_missions.owl | Ontology values are untested - vulnerability (0.01), risk threshold (0.6), interval calibration factors (2, 3) and freeway speed probabilities agree with the classifications and the `operation_5b` model today, but no test pins them; check with `grep -n ontology mission-executive/test/*.rb`.
- 2026-11-19 | f061c32 | .gitignore .rubocop.yml | Gem versions are unpinned - `Gemfile.lock` is ignored and `NewCops: enable` is set, so a fresh `just install` can pull a newer RuboCop whose new cops fail `just lint` and block the pre-push hook; check with `git check-ignore Gemfile.lock`.
