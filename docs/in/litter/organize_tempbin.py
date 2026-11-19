#!/usr/bin/env --split-string=uv run --script
################
# Created/Changed using: Codex (GPT-6)
# TODO: HUMAN VERIFICATION PENDING :FIXME
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
Sort downloaded binaries, man pages, and completions using ouch.

Archive documentation is retained with package suffixes; loose documentation
is retained as-is. Existing files are never overwritten. The ouch executable must be on PATH when
archives are present.
"""

import gzip
import shutil
import subprocess
import tempfile
from pathlib import Path

from cyclopts import App
from pydantic import DirectoryPath, validate_call
from rich import print
from rich.text import Text

app = App()
ARCHIVE_SUFFIXES = (".tar", ".tar.gz", ".tar.xz", ".tgz", ".zip")
PLATFORM_SUFFIXES = tuple(
    separator + platform
    for separator in ("-", "_", ".")
    for platform in (
        "x86_64",
        "x86-64",
        "amd64",
        "aarch64",
        "arm64",
        "linux",
        "windows",
        "darwin",
        "musl",
        "gnu",
    )
)


def _is_documentation(path: Path) -> bool:
    """
    Identify documentation files.

    Parameters
    ----------
    path : Path
        File to classify.

    Returns
    -------
    bool
        Whether the filename identifies documentation.
    """
    name = path.name.lower()
    return (
        path.suffix.lower() in {".md", ".markdown"}
        or "license" in name
        or name in {"copying", "unlicense"}
    )


def _is_binary(path: Path) -> bool:
    """
    Recognize executables without reading their entire contents.

    Parameters
    ----------
    path : Path
        File to inspect.

    Returns
    -------
    bool
        Whether executable permission bits or an ELF header are present.
    """
    if path.stat().st_mode & 0o111:
        return True
    with path.open("rb") as source:
        return source.read(4) == b"\x7fELF"


def _category(path: Path) -> str | None:
    """
    Classify an extracted file by name, directory, and contents.

    Parameters
    ----------
    path : Path
        Extracted file to classify.

    Returns
    -------
    str | None
        Destination category, or None for an unrecognized file.
    """
    if _is_documentation(path):
        return "docs"
    if path.name.endswith((".1", ".1.gz")):
        return "man"
    if path.suffix in {".bash", ".fish", ".zsh", ".nu", ".ps1", ".elv"}:
        return "completions"
    if any("complet" in part.lower() for part in path.parent.parts):
        return "completions"
    return "bin" if _is_binary(path) else None


def _binary_name(name: str) -> str:
    """
    Strip repeated architecture and platform suffixes.

    Parameters
    ----------
    name : str
        Original binary filename.

    Returns
    -------
    str
        Filename with recognized trailing platform tokens removed.
    """
    while suffix := next(
        (
            suffix
            for suffix in PLATFORM_SUFFIXES
            if name.lower().endswith(suffix)
        ),
        "",
    ):
        name = name[: -len(suffix)]
    return name


def _decompress(source: Path, destination: Path) -> None:
    """
    Decompress a man page and remove its compressed source.

    Parameters
    ----------
    source : Path
        Compressed man page.
    destination : Path
        New output file; must not already exist.

    Raises
    ------
    OSError
        If decompression fails because of invalid data or an I/O error.
    EOFError
        If the compressed input is truncated.

    Notes
    -----
    Incomplete output is removed if decompression fails.
    """
    with destination.open("xb") as target:
        try:
            with gzip.open(source, "rb") as compressed:
                shutil.copyfileobj(compressed, target)
        except (OSError, EOFError):
            destination.unlink()
            raise
    source.unlink()


def _install(source: Path, destination: Path) -> None:
    """
    Move a file or decompress a man page without replacing files.

    Parameters
    ----------
    source : Path
        File to install.
    destination : Path
        New installation path.

    Raises
    ------
    FileExistsError
        If the destination already exists, including a dangling symlink.
    """
    destination.parent.mkdir(parents=True, exist_ok=True)
    if destination.exists() or destination.is_symlink():
        raise FileExistsError(destination)
    if source.name.endswith(".1.gz"):
        _decompress(source, destination)
    else:
        shutil.move(source, destination)


def _install_member(item: Path, root: Path, package: str) -> None:
    """
    Install a recognized archive member under its normalized name.

    Parameters
    ----------
    item : Path
        Extracted file to classify and install.
    root : Path
        Root containing the destination directories.
    package : str
        Package name derived from the archive filename.
    """
    category = _category(item)
    if category is None:
        return
    name = item.name
    if category == "man":
        name = name.removesuffix(".gz")
    elif category == "bin":
        name = _binary_name(name)
    elif category == "docs":
        name = f"{item.stem}_{package}{item.suffix}"
    _install(item, root / category / name)


def _unpack(archive: Path, root: Path) -> None:
    """
    Install recognized archive members before removing the archive.

    Parameters
    ----------
    archive : Path
        Archive to decompress using ouch.
    root : Path
        Root containing the destination directories.
    """
    with tempfile.TemporaryDirectory(dir=root) as temporary:
        subprocess.run(
            ["ouch", "decompress", "--yes", "--dir", temporary, str(archive)],
            check=True,
        )
        package = archive.name
        for suffix in ARCHIVE_SUFFIXES:
            if package.endswith(suffix):
                package = package[: -len(suffix)]
                break
        package = _binary_name(package)
        for item in sorted(Path(temporary).rglob("*")):
            if item.is_file():
                _install_member(item, root, package)
    archive.unlink()


def _unpack_archives(root: Path) -> None:
    """
    Process supported archives in a deterministic order.

    Parameters
    ----------
    root : Path
        Download directory containing archives.
    """
    for archive in sorted(root.iterdir()):
        if archive.is_file() and archive.name.endswith(ARCHIVE_SUFFIXES):
            _unpack(archive, root)


def _organize_loose(root: Path) -> None:
    """
    Retain loose documentation and install loose executables.

    Parameters
    ----------
    root : Path
        Download directory to organize.
    """
    for item in filter(Path.is_file, sorted(root.iterdir())):
        if not _is_documentation(item) and _is_binary(item):
            _install(item, root / "bin" / _binary_name(item.name))


@app.default
@validate_call
def organize(
    directory: DirectoryPath = Path(__file__).parent / "tempbin",
) -> None:
    """
    Organize downloads into bin, man, completions, and docs directories.

    Parameters
    ----------
    directory : DirectoryPath, default=Path(__file__).parent / "tempbin"
        Existing download directory. Defaults to tempbin beside this
        script.
    """
    root = Path(directory).resolve()
    _unpack_archives(root)
    _organize_loose(root)
    for binary in sorted((root / "bin").glob("*")):
        destination = binary.with_name(_binary_name(binary.name))
        if destination != binary:
            _install(binary, destination)
    for manpage in sorted((root / "man").glob("*.1.gz")):
        _install(manpage, manpage.with_suffix(""))
    print(Text(f"Organized {root}"))


if __name__ == "__main__":
    app()
