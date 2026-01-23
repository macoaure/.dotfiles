# Testing Instructions

## Overview
All tests must run in Docker containers to ensure isolation and avoid system modifications. Tests are grouped into unit, feature, and integration categories. Use the `tests/run-all.sh` script to execute all tests sequentially.

## Test Groups

### Unit Tests
- **Purpose**: Validate individual components (e.g., Ansible syntax, linting).
- **Examples**: Syntax checks, linting roles, template validation.
- **Docker Setup**: Use lightweight images (e.g., `ubuntu:20.04`).
- **Commands**: `ansible-playbook --syntax-check`, `ansible-lint`.

### Feature Tests
- **Purpose**: Test specific features or roles (e.g., installing a package via Ansible).
- **Examples**: Role-specific tasks, template rendering.
- **Docker Setup**: Use images matching target OS (e.g., `debian:11` for Debian roles).
- **Commands**: Targeted playbook runs with `--tags`.

### Integration Tests
- **Purpose**: Validate full system integration (e.g., end-to-end playbook execution).
- **Examples**: Complete setup, cross-role interactions.
- **Docker Setup**: Full environment simulation with volumes.
- **Commands**: Full `ansible-playbook` runs.

## Creating Tests
1. **Unit**: Add scripts in `tests/unit/` (e.g., `test-syntax.sh`).
2. **Feature**: Create `tests/feature/<role>.sh` for role tests.
3. **Integration**: Use `tests/integration/test-full.sh` for end-to-end.
4. Write tests as Bash scripts calling Ansible commands.
5. Use Docker in scripts: `docker run --rm -v $(pwd):/repo <image> <command>`.

## Validating Tests
- Run individual test scripts manually.
- Check exit codes: 0 for pass, non-zero for fail.
- Review Docker logs for errors.
- Use `docker exec` for debugging inside containers.
- Ensure no host system changes.
- **Output Design**: Follow PestPHP-style output – simple, concise, developer-focused. Use colors (green for pass, red for fail), minimal text, clear summaries (e.g., "PASS: Syntax Check", "FAIL: Lint Errors"). Avoid verbose logs; show only essential info.
- **Examples**:
  - Simple Pass: `PASS  Unit: Syntax Check ✓ All playbooks valid`
  - Simple Fail: `FAIL  Feature: Zsh Role ✗ Template rendering failed`
  - Detailed Block:
    ```
    Running tests...

    PASS  Unit: Syntax Check
      ✓ playbook.yml syntax OK
      ✓ roles/zsh/tasks/main.yml syntax OK

    FAIL  Feature: Vim Role
      ✗ Template .vimrc.j2 renders correctly
        Expected: 'set number'
        Got: 'set nonumber'

    Tests: 3 passed, 1 failed. Time: 2.3s
    ```
- **Automation**: All tests must run automatically without user interaction. No prompts or inputs required; use defaults or scripted values.

## Docker Container Setup
- **Base Images**: Choose based on test needs (e.g., `ubuntu`, `centos`).
- **Volumes**: Mount repo: `-v $(pwd):/repo`.
- **Environment**: Set Ansible vars if needed.
- **Cleanup**: Use `--rm` for auto-removal.
- **Example**: `docker run --rm -v $(pwd):/repo ubuntu:20.04 bash -c "cd /repo && ansible-lint roles/"`

## Running All Tests
- Execute `tests/run-all.sh` to run unit, feature, integration in order.
- Script checks Docker availability and runs each group in containers.
- Output: Pass/fail summary; stop on first failure or continue based on config.
- CI Integration: Use in GitHub Actions with Docker runners.

## Rules
- Never run tests directly on host; always use Docker.
- Update `run-all.sh` when adding new tests.
- Document test purposes in script comments.
- Test on multiple OS images for cross-platform validation.