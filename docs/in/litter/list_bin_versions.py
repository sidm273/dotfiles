#!/usr/bin/env --split-string=uv run --script
################
# Created/Changed using: Codex (GPT-6)
# HUMAN VERIFICATION: LGTM
################
# /// script
# requires-python = ">=3.14"
# dependencies = [
#     "cyclopts",
#     "pydantic>=2",
#     "rich",
# ]
# ///
"""
Print the first version or help line from each downloaded binary.

Only run this script on binaries you trust: each file is executed with
--version and, when necessary, --help, with a five-second timeout per
call.
"""

import subprocess
from pathlib import Path

from cyclopts import App
from pydantic import DirectoryPath, validate_call
from rich import print
from rich.text import Text

app = App()


def _version_output(binary: Path) -> str:
    """
    Run version or help and return its output.

    Parameters
    ----------
    binary : Path
        Binary to execute with a five-second timeout per call.

    Returns
    -------
    str
        Version output, help output, or an empty string.
    """
    output = ""
    for option in ("--version", "--help"):
        result = subprocess.run(
            [str(binary.resolve()), option],
            capture_output=True,
            text=True,
            errors="replace",
            timeout=5,
            check=False,
        )
        output = (result.stdout or result.stderr).strip()
        if result.returncode == 0 or output:
            break
    return output


def _version(binary: Path) -> str:
    """
    Return the first version/help line, or an execution error.

    Parameters
    ----------
    binary : Path
        Binary to execute with a five-second timeout per call.

    Returns
    -------
    str
        First output line, error message, or an empty-output message.
    """
    try:
        output = _version_output(binary)
    except (OSError, subprocess.TimeoutExpired) as error:
        output = str(error)
    return next(iter(output.splitlines()), "no version/help output")


@app.default
@validate_call
def list_versions(
    directory: DirectoryPath = Path(__file__).parent / "tempbin" / "bin",
) -> None:
    """
    List binary names with their first version or help output line.

    Parameters
    ----------
    directory : DirectoryPath, default=Path(__file__).parent / "tempbin" / "bin"
        Existing binary directory. Defaults to tempbin/bin beside this
        script.
    """
    for binary in sorted(Path(directory).iterdir()):
        if binary.is_file():
            print(Text(f"{binary.name}: {_version(binary)}"))


if __name__ == "__main__":
    app()
