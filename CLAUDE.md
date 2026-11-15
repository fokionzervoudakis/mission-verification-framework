# CLAUDE.md

A research project that verifies UAV mission plans. Each mission exists in several forms that must stay in step.

## Forms

| Form | Where |
| --- | --- |
| Plan | `mission-executive/operations/operation_*.yaml` |
| PRISM model | `models/operation_*/operation_*.pm` and `.pctl` |
| Prolog | `prolog-kb/operation_*.pl` (16 plans only) |
| Classification | `mission-executive/classifications/operation_*.yaml` |
| Executive | `mission-executive/mission.rb`, `asset.rb`, `action.rb` |
| Ontology | `ontology/*.owl` (domain classes and limits; missions 4a, 4b, 4c, 5a, 5b and A) |

## What must agree

- **Plan and model**: actions, owning asset, preconditions, durations, intervals, endurance, and "point of failure" comments.
- **Plan and Prolog**: ownership and preconditions of kinetic actions.
- **Classification and Prolog**: every class in a classification file is confirmed by the Prolog rules.
- **Classification and model**: the model's shared step is named after one of the primary assets (`asst1` is asset 1). A plan can have several primary assets; the model uses one.
- **Executive and model**: whether all actions complete.
- **Ontology and plan**: for the missions with an ontology file, the actions, owning asset, preconditions and lidar concurrency.
- **Ontology and the rest**: the endurance limit of each asset type (`asset_data.yaml` and the schema), vulnerability and risk threshold (classification and model), interval calibration factors and freeway speed probabilities (`operation_5b` model), and the classes behind the Prolog rules.

Known exceptions are in `docs/improve.md`.

## Rules

- No single form is the reference. When forms disagree, compare all of them, report which agree, and ask. Do not pick a side and edit.
- Where the executive runs a plan differently from its model, the executive is the side to change.
- Never change one form alone. Update the others in the same commit, comments included.
- After changing a model, rerun PRISM and say whether any result changed.
- Do not edit anything while auditing or answering a question.

## Tests are not enough

`just test` does not check action guards, plan against Prolog, "point of failure" comments, the primary asset, the ontology (apart from endurance limits), or generator output that goes missing. Check these by reading the files.

## Regenerate after a change

| File | Command |
| --- | --- |
| `data/model-results.csv` | `just verify` |
| `data/model-states/` | `just states` |
| `data/mission-metrics.csv` | `just parse` |
| `data/model-comparison.md` | Edit by hand |

## Intentional gaps

- `just generate` prints only parts of a model. Missing output is not a defect.
- The executive does not model threat areas or sensing.
