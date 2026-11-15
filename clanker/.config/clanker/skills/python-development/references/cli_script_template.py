#!/usr/bin/env --split-string=uv run --script
# /// script
# requires-python = ">=3.14"
# dependencies = [
#     "pydantic>=2",
#     "cyclopts",
#     "boltons",
#     "rich",
#     "plumbum",
# ]
# ///
"""Minimal standalone script demonstrating Pydantic function validation."""

from boltons.iterutils import flatten
from cyclopts import App
from plumbum import local
from pydantic import validate_call
from rich import print

app = App()


@validate_call
def greet(name: str, repeat: int = 1) -> str:
    """Return a greeting, repeated the requested number of times."""
    return " ".join([f"Hello, {name}!" for _ in range(repeat)])


@app.default
def main(name: str, repeat: int = 1) -> None:
    print(greet(name, repeat=repeat))
    a = [1, 2, [3, 4]]
    print(f"{a} is flattened to {flatten(a)}")
    print("Current directory entries:")
    for path in local.cwd.list():
        print(path.name)
        print(path.name)


if __name__ == "__main__":
    app()
