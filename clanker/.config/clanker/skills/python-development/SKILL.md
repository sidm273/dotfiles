---
name: python-development
description: >
    Conventions for writing, generating, or reviewing Python code.
    Doc lookup order, code style, citations, and required lint/type verification.
    Use whenever writing or modifying Python code or scripts.
license: MIT
compatibility: Requires python>=3.12
metadata:
  author: Sid L
---

## Code style

- Style decisions and Code QA is enforced using Linters, Formatters and type
  checkers; which are run as a pre-commit hook. Reference project specific
  `README.md` for instructions on how to run QA.
- Generate fully typed, PEP8 compliant Python code which passes the QA.
- Never add linter or type-checker ignores. If it is a blocker, ask the user to
  add it manually and justify it's need.
- Docstrings are the single source of truth for implementation details specific
  to the code — read them for context, and write them with the same intent when
  generating code. Use project default style for docstrings, and fallback to
  numpy style docstrings. Try adding basic examples within docstrings.
- **ALL** regular expressions must use verbose mode with explanatory comments.

## Context lookup order

1. Project-level `pyproject.toml` for the current project. If absent, use the
   tool defaults, and **inform the user.**
2. Library specific agent skills/MCP servers take priority in case of conflict
   with the instructions here, **but inform the user** about the conflict.
3. `references/`: utilize these in absence of agent skills. It contains
   `llms.txt` for initial context and complete details at `llms_full.txt`

## Citations

In addition to top-level citation requirements

- Claims about source code in the current repository: `path:line`.
- Third-party libraries with offline docs: `path:line` plus 5 additional lines
  of context.

## Modes

The user will specify certain modes when interacting.

- `snip`, `quick`: Indicates snippet mode. (Default)
- `pair`: Indicates pair programming mode.
- `scripts`: User wants a standalone script with PEP723 inline metadata.

### snippet mode

- Generate quick snippets or examples for the requested functionality.
- Usually involves `how to do task X in python`.
- Utilize `low thinking` for quick responses.
- Try minimal copyable snippets if possible.
- Don't be verbose and keep comments only if absolutely necessary for
  understanding.
- Provide a minimal asserts for user to try it out.

### Pair programming mode

- Nudge user to use `marimo-pair` for pair programming. Only if user requests
  not using it in the session utilize the instructions in this section.
- If generating explanatory scripts or code snippets which user will run in
  REPL, utilize the following snippet with modifications.

```py
import rich
rich.pretty.install()
rich.traceback.install(show_locals=True, suppress=[<framework_libs>])
rich.inspect()
```

### standalone script

Use `references/cli_script_template.py` as a starting point for one-off scripts,
CLI utilities, prototypes, or replacing a shell script with Python. Keep only
the template dependencies the script actually uses. Prefer using the following
libraries. **Only If the user explicitly requests** a zero-dependency script,
remove external dependencies from both the metadata and code.

- Use Cyclopts for CLI.
- Pydantic `@validate_call` for function input validation.
- `rich.print` for output.
- Use Plumbum for shell or filesystem operations when needed.

Standalone scripts use PEP 723 metadata and should be executable so they can run
directly.

## Verification loop

- If QA is configured, your task is not done until QA passes.
- If QA is not configured, run a basic QA using `ruff` and `ty` with defaults.
- If 20 fix-and-check cycles fail to resolve QA, stop retrying; report what
  failed, what you tried, and the smallest remaining blocker.
