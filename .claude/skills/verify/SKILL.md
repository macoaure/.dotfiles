---
name: verify
description: Run the full test suite (unit + feature + integration) in Docker. Use after making changes to playbooks, Stow packages, or test scripts.
---

Run the full test suite to verify the current state of the repo:

```bash
./tests/run-all.sh
```

If tests fail, show the failing test names and output. Suggest fixes based on the failure messages.

If the user passes `--verbose` as an argument, run:

```bash
./tests/run-all.sh --verbose
```

Do not modify the host system during verification — all tests run in Docker containers.
