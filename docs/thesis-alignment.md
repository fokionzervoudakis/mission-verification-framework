# Thesis alignment

An audit of the commits up to `7ec6e3f` against the thesis this repository supports: *Cascading Verification: An Integrated Method for Domain-Specific Model Checking* (University College London).

No commit changes a PRISM result. Mission A still succeeds with probability 0.299, and Mission 5b still gives 0.651 and 0.625.

## Changes

| Change | Commit | Aligns with the thesis? | Improvement? |
| --- | --- | --- | --- |
| Two-phase tick in the executive | `37eb61b` | Yes, follows the models | Yes, fixes a bug |
| No endurance before an asset starts | `cecd2d6` | Yes, follows the models | Yes |
| Sensor actions only while flying | `249e012` | Yes, follows the models | Yes |
| Mission ends when an asset in flight has to wait | `bf80691` | Yes (sections 5.3 and 6.1.3) | Yes |
| Unfinished actions reported | `c4b134f` | Not covered | Yes |
| Duplicate, unknown and misowned ids rejected | `9c24e07`, `3cd5b1d`, `8f94cdd` | Yes (section 6.1.2) | Yes |
| Misused lidar actions rejected | `9b7b955`, `ba63576` | Yes (section 4.1.3) | Yes |
| Durations and intervals at least 1 | `49566ee` | Not stated | Yes, minor |
| Per-asset endurance, up to the type's limit | `82c5083` | Yes (section 3.1, Listing 5.1) | Yes |
| `operation_2q` duration matched to its model | `01ead5a` | Yes (section 6.1.2) | Yes |
| `operation_2u` model waits on action 5 | `57ae18f` | Yes for the plan; Listing F.46 has the slip | Yes |
| `operation_A` photo action checks its own asset | `b70c9de` | Yes | Yes |
| `operation_4b` marked as a point of failure | `7f7ce9d` | Partly: it fails, but the thesis counts 18 marked plans | Neutral |
| Primary asset chosen once per plan | `c4dccf1` | Yes (section 5.3) | Yes |
| `coordinates` key counted as a token | `9b1eb3f` | No, changes Table 6.1 | Yes |
| Comment markers not counted as tokens | `5f354d2` | In intent (section 6.2.1), not in the figures | Yes |
| PRISM results recorded and compared | `cb5031d`, `fb0d67e` | Not covered | Yes |
| Model states exported | `f22cd92` | Not covered | Yes |
| Tests pinning the forms to each other | `d894e9e`, `a193940`, `1372cca` | Not covered | Yes |
| `CLAUDE.md` alignment rules | `df555fd`, `1db48df`, `7ec6e3f` | Not covered | Yes |

## Accepted differences

- **Token figures.** The thesis reports token ratios of 4.490 for all plans and 5.992 for tactical plans; the repository gives 4.271 and 5.636.
- **Marked plans.** The thesis counts 18 plans seeded with errors; 19 now carry a "point of failure" comment.
- **Appendix listings.** The appendices are a snapshot; the schema, the `operation_2u` model and the Ruby code have moved on.
