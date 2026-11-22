# README

This is the repository for a project that verifies the correctness of complex *uninhabited aerial vehicle* (UAV) mission plans.

Install the project.

```bash
git clone git@github.com:zerdaks/uav-missions.git
cd uav-missions/
just install
```

Validate all mission plans, or one plan given by its path from the repository root. The second command checks a plan that is invalid on purpose, so it reports the error and fails.

```bash
just validate
just validate mission-executive/test/invalid_plan.yaml
```

Execute individual mission plans. Use the optional parameter ```filter``` to output the execution stack of each method call to the standard output stream.

```bash
(cd mission-executive/; \
./mission.rb operation_1a; \
./mission.rb filter operation_1a)
```

Execute all mission plans.

```bash
just execute
```

Lint sources and test the mission executive.

```bash
just lint test
```

Generate *PRISM DTMC/PCTL* code from templates.

```bash
just generate
```

Use *SWI-Prolog* to classify UAV mission elements.

```bash
just classify

cd prolog-kb
swipl
?- [operation_1a].
?- halt.
```

Verify the *PRISM* models. Requires [PRISM](https://www.prismmodelchecker.org).

```bash
just verify
```

Export the states (`.sta`) and transitions (`.tra`) of the *PRISM* models to `data/model-states/`. Requires [PRISM](https://www.prismmodelchecker.org).

```bash
just states
```

Execute the parser.

```bash
just parse
```
