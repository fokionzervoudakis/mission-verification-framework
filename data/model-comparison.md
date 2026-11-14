# Model comparison

One row per plan: what the YAML marks, what PRISM computes for the model, and what the executive does.

Model and executive agree on 52 of 58 plans and disagree on 6.

- **YAML mark**: the plan has a "point of failure" comment.
- **PRISM: mission succeeds**: the probability that the property in the plan's `.pctl` file holds. 1.0 is always, 0.0 is never.
- **PRISM: actions complete**: the probability that the final actions complete. It differs from "mission succeeds" only for the plans with a threat area, where success also requires the asset to survive and to sense enough.
- **Executive says**: the output of `mission-executive/mission.rb`, which only checks that actions complete.
- **Agree**: compares "PRISM: actions complete" with the executive, since that is the one question both answer.

Every PRISM result, including the two extra properties of `operation_5b`, is in [model-results.csv](model-results.csv).

| Plan | YAML mark | PRISM: mission succeeds | PRISM: actions complete | Executive says | Agree |
| --- | --- | --- | --- | --- | --- |
| operation_1a |  | 1.0 | 1.0 | all actions completed | yes |
| operation_1b |  | 1.0 | 1.0 | all actions completed | yes |
| operation_1c | point of failure | 0.0 | 0.0 | unfinished actions: 1 | yes |
| operation_1d |  | 1.0 | 1.0 | all actions completed | yes |
| operation_1e | point of failure | 0.0 | 0.0 | unfinished actions: 2 | yes |
| operation_1f | point of failure | 0.0 | 0.0 | unfinished actions: 2 | yes |
| operation_1g |  | 1.0 | 1.0 | all actions completed | yes |
| operation_2a |  | 1.0 | 1.0 | all actions completed | yes |
| operation_2b |  | 1.0 | 1.0 | all actions completed | yes |
| operation_2c |  | 1.0 | 1.0 | all actions completed | yes |
| operation_2d | point of failure | 0.0 | 0.0 | all actions completed | no |
| operation_2e |  | 1.0 | 1.0 | all actions completed | yes |
| operation_2f | point of failure | 0.0 | 0.0 | all actions completed | no |
| operation_2g |  | 1.0 | 1.0 | unfinished actions: 3, 4, 5 | no |
| operation_2h |  | 1.0 | 1.0 | unfinished actions: 3, 4, 5 | no |
| operation_2i | point of failure | 0.0 | 0.0 | unfinished actions: 3, 4, 5 | yes |
| operation_2j |  | 1.0 | 1.0 | all actions completed | yes |
| operation_2k |  | 1.0 | 1.0 | all actions completed | yes |
| operation_2l | point of failure | 0.0 | 0.0 | unfinished actions: 3 | yes |
| operation_2m |  | 1.0 | 1.0 | all actions completed | yes |
| operation_2n |  | 1.0 | 1.0 | all actions completed | yes |
| operation_2o | point of failure | 0.0 | 0.0 | unfinished actions: 3 | yes |
| operation_2p |  | 1.0 | 1.0 | all actions completed | yes |
| operation_2q | point of failure | 0.0 | 0.0 | unfinished actions: 3 | yes |
| operation_2r |  | 1.0 | 1.0 | all actions completed | yes |
| operation_2s |  | 1.0 | 1.0 | all actions completed | yes |
| operation_2t | point of failure | 0.0 | 0.0 | all actions completed | no |
| operation_2u |  | 1.0 | 1.0 | all actions completed | yes |
| operation_2v |  | 1.0 | 1.0 | all actions completed | yes |
| operation_2w |  | 1.0 | 1.0 | all actions completed | yes |
| operation_2x |  | 1.0 | 1.0 | all actions completed | yes |
| operation_3a |  | 1.0 | 1.0 | all actions completed | yes |
| operation_3b |  | 1.0 | 1.0 | all actions completed | yes |
| operation_3c | point of failure | 0.0 | 0.0 | all actions completed | no |
| operation_3d | point of failure | 0.0 | 0.0 | unfinished actions: 2 | yes |
| operation_3e |  | 1.0 | 1.0 | all actions completed | yes |
| operation_3f |  | 1.0 | 1.0 | all actions completed | yes |
| operation_3g | point of failure | 0.0 | 0.0 | unfinished actions: 3 | yes |
| operation_3h |  | 1.0 | 1.0 | all actions completed | yes |
| operation_3i |  | 1.0 | 1.0 | all actions completed | yes |
| operation_3j | point of failure | 0.0 | 0.0 | unfinished actions: 3 | yes |
| operation_3k |  | 1.0 | 1.0 | all actions completed | yes |
| operation_3l |  | 1.0 | 1.0 | all actions completed | yes |
| operation_3m |  | 1.0 | 1.0 | all actions completed | yes |
| operation_3n | point of failure | 0.0 | 0.0 | unfinished actions: 4 | yes |
| operation_3o |  | 1.0 | 1.0 | all actions completed | yes |
| operation_3p |  | 1.0 | 1.0 | all actions completed | yes |
| operation_3q |  | 1.0 | 1.0 | all actions completed | yes |
| operation_3r | point of failure | 0.0 | 0.0 | unfinished actions: 4 | yes |
| operation_4a |  | 1.0 | 1.0 | all actions completed | yes |
| operation_4b |  | 0.0 | 1.0 | all actions completed | yes |
| operation_4c | point of failure | 0.0 | 1.0 | all actions completed | yes |
| operation_4d |  | 0.4948 | 1.0 | all actions completed | yes |
| operation_4e | point of failure | 0.0 | 1.0 | all actions completed | yes |
| operation_4f |  | 0.4948 | 1.0 | all actions completed | yes |
| operation_5a |  | 1.0 | 1.0 | all actions completed | yes |
| operation_5b |  | 1.0 | 1.0 | all actions completed | yes |
| operation_A |  | 0.2994 | 1.0 | all actions completed | yes |
