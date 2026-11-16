#!/usr/bin/env --split-string=uv run --script
# /// script
# requires-python = ">=3.14"
# dependencies = [
#     "pyperclip",
#     "cyclopts",
# ]
# ///
"""
Copy and paste files from/to clipboard with hash verification.

Notes
-----
- Author: Sid
- License: MIT

"""

import sys
from hashlib import sha256
from pathlib import Path

import pyperclip as clip
from cyclopts import App

app = App()
CWD = Path.cwd()


@app.command()
def to_clip(file_path: str | Path, debug: bool = False) -> None:
    """Copy the contents of a file to the clipboard with metadata.

    Parameters
    ----------
    file_path : str | Path
        The path to the file whose contents are to be copied to the clipboard.
    """
    p = Path(file_path)
    text = p.read_text(encoding="utf-8")
    digest = sha256(text.encode("utf-8")).hexdigest()
    clip.copy(
        "\n".join(
            (
                f"FILE={p.name}",
                f"SHA256={digest}",
                "===CONTENTS===",
                f"{text}",
            )
        )
    )
    print(f"Contents of {p.name} copied to clipboard.")
    if debug:
        print(f"SHA256 hash: {digest}")
        print(f"Clipboard contents:\n{clip.paste()}")


@app.command()
def from_clip(
    dir_path: str | Path = CWD, check: bool = True, debug: bool = False
) -> None:
    """Paste the contents of clipboard in a specific format to a file.

    Parameters
    ----------
    dir_path : str | Path
        The path to the directory where the contents from the clipboard will be pasted.
        Default is the current working directory.
    check : bool
        If True, checks if the SHA256 hash of the pasted content matches the hash in the clipboard metadata.
        If False, skips the hash check.
    """
    dir = Path(dir_path)
    if check:
        header, _, text = clip.paste().partition("===CONTENTS===\n")
        if text == "":
            print(
                "Clipboard contents are not in the expected format. Contents not pasted."
            )
            sys.exit(1)
        name = header.splitlines()[0].removeprefix("FILE=")
        digest = header.splitlines()[1].removeprefix("SHA256=")
        checksum = sha256(text.encode("utf-8")).hexdigest()
        p = dir / name
        if debug:
            print(f"{name=}")
            print(f"{digest=}")
            print(f"{checksum=}")
            print(f"{text=}")
        if checksum == digest:
            p.write_text(text, encoding="utf-8")
            print(f"Contents of {name} pasted to {p.name}.")
        else:
            print(f"SHA256 hash mismatch. Contents not pasted to {p.name}.")
    else:
        p = dir / "pasted_file.txt"
        p.write_text(clip.paste(), encoding="utf-8")
        print(f"Contents pasted to {p.name} as-is.")


if __name__ == "__main__":
    app()
