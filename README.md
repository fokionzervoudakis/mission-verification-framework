# README

This is the repository for a project that verifies the correctness of complex *uninhabited aerial vehicle* (UAV) mission plans.

Install the project.

```bash
git clone git@github.com:zerdaks/uav-missions.git
cd uav-missions/
make install
```

Validate mission plans.

```bash
make validate
```

Execute individual mission plans. Use the optional parameter ```filter``` to output the execution stack of each method call to the standard output stream.

```bash
(cd mission-executive/; \
./mission.rb operation_1a; \
./mission.rb filter operation_1a)
```

Execute all mission plans.

```bash
make execute
```

Generate *PRISM DTMC/PCTL* code from templates.

```bash
make generate
```

Use *SWI-Prolog* to classify UAV mission elements.

```bash
make classify

cd prolog-kb
swipl
?- [operation_1a].
?- halt.
```

Execute the parser.

```bash
make parse
```
