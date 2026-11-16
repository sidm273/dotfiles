################
# Created/Changed using: Codex
# TODO: HUMAN VERIFICATION PENDING :FIXME
################
"""Typed gh arguments, serialized by pydantic-settings.

Build validated argument lists for release download, list, and view. Execution,
checksum verification, and executable permissions belong to the caller.

Examples
--------
>>> command = GhReleaseDownload(tag="v1", pattern=["*.deb"], directory="build")
>>> command.to_argv()
['gh', 'release', 'download', 'v1', '--dir', 'build', '--pattern', '*.deb']

Execute with subprocess when ready::

    import subprocess

    subprocess.run(command.to_argv(), check=True)

Or, with plumbum installed::

    from plumbum import FG, local

    program, *arguments = command.to_argv()
    local[program][arguments] & FG

Notes
-----
Each command reads its own environment prefix: ``GH_RELEASE_DOWNLOAD_``,
``GH_RELEASE_LIST_``, or ``GH_RELEASE_VIEW_``. Aliases use flag names, such as
``GH_RELEASE_DOWNLOAD_DIR`` and ``GH_RELEASE_LIST_JSON``. Explicit arguments
win; list environment values use JSON, e.g. ``["*.deb", "*.rpm"]``. Generic
``REPO``, ``DIR``, and ``JSON`` variables are ignored. These settings do not
change the child process environment; subprocess/plumbum inherit it normally.

Run ``just test`` for tests and doctests, and ``just lint`` for Ruff formatting,
lint, and ty checks. Live GitHub downloads have not been verified.

References
----------
https://cli.github.com/manual/gh_release
https://docs.pydantic.dev/latest/concepts/pydantic_settings/#cli-serialization
"""

from typing import Annotated, ClassVar, Literal, Self

from pydantic import Field, StringConstraints, model_validator
from pydantic_settings import BaseSettings, CliApp, CliPositionalArg, SettingsConfigDict

Tag = Annotated[
    str,
    StringConstraints(
        min_length=1,
        pattern=r"""(?x)
            ^ [^-]  # A leading dash would make gh interpret the tag as an option.
        """,
    ),
]


class CliModel(BaseSettings):
    """Share flag formatting; leave command execution to the caller.

    Notes
    -----
    Set command words with a ``ClassVar`` so they stay out of model fields.
    Name flags with ``Field(alias=...)``; serialization aliases are ignored by
    ``CliApp.serialize``. Underscores become hyphens, booleans are bare flags,
    and lists repeat their flag. Values equal to declared defaults are omitted,
    even when explicitly supplied. Use ``None`` for optional list defaults.
    """

    model_config = SettingsConfigDict(
        cli_implicit_flags=True,
        cli_kebab_case=True,
        populate_by_name=True,
        env_prefix_target="all",  # Prefix aliased fields such as --dir too.
    )
    command: ClassVar[tuple[str, ...]]

    def to_argv(self) -> list[str]:
        """Serialize positional arguments first, followed by flags.

        Returns
        -------
        list[str]
            Command words and arguments for subprocess or plumbum. Pass these
            directly without a shell to preserve spaces and metacharacters.
        """
        return [
            *self.command,
            *CliApp.serialize(self, list_style="argparse", positionals_first=True),
        ]


class GhReleaseDownload(CliModel):
    """Arguments for gh release download.

    Notes
    -----
    ``tag=None`` selects the latest release and requires a pattern or archive.
    Tags must be nonempty and cannot begin with a dash, including values read
    from the environment. ``directory`` maps to ``--dir``; ``output="-"``
    selects stdout. Patterns repeat ``--pattern`` for each item.

    Directory/output, pattern/archive, and clobber/skip-existing are mutually
    exclusive pairs, checked during model validation.
    """

    model_config = SettingsConfigDict(env_prefix="GH_RELEASE_DOWNLOAD_")
    command: ClassVar[tuple[str, ...]] = ("gh", "release", "download")

    tag: CliPositionalArg[Tag | None] = None
    repo: str | None = None
    directory: str | None = Field(default=None, alias="dir")
    output: str | None = None
    pattern: list[str] | None = None
    archive: Literal["zip", "tar.gz"] | None = None
    clobber: bool = False
    skip_existing: bool = False

    @model_validator(mode="after")
    def check_options(self) -> Self:
        """Reject combinations gh cannot execute."""
        if self.tag is None and not self.pattern and self.archive is None:
            raise ValueError("without a tag, gh requires --pattern or --archive")
        for left, left_set, right, right_set in (
            ("--dir", self.directory is not None, "--output", self.output is not None),
            ("--pattern", bool(self.pattern), "--archive", self.archive is not None),
            ("--clobber", self.clobber, "--skip-existing", self.skip_existing),
        ):
            if left_set and right_set:
                raise ValueError(f"{left} and {right} are mutually exclusive")
        return self


class GhReleaseList(CliModel):
    """Arguments for gh release list.

    Notes
    -----
    ``limit`` must be positive. ``json_fields`` maps to ``--json`` and takes a
    comma-separated string, for example ``"tagName,isLatest"``.
    """

    model_config = SettingsConfigDict(env_prefix="GH_RELEASE_LIST_")
    command: ClassVar[tuple[str, ...]] = ("gh", "release", "list")

    repo: str | None = None
    limit: int = Field(default=30, gt=0)
    order: Literal["asc", "desc"] = "desc"
    exclude_drafts: bool = False
    exclude_pre_releases: bool = False
    json_fields: str | None = Field(default=None, alias="json")
    jq: str | None = None
    template: str | None = None


class GhReleaseView(CliModel):
    """Arguments for gh release view.

    Notes
    -----
    ``tag=None`` selects the latest release. Supplied tags must be nonempty and
    cannot begin with a dash. ``json_fields`` maps to ``--json`` and takes a
    comma-separated string, for example ``"tagName,assets"``.
    """

    model_config = SettingsConfigDict(env_prefix="GH_RELEASE_VIEW_")
    command: ClassVar[tuple[str, ...]] = ("gh", "release", "view")

    tag: CliPositionalArg[Tag | None] = None
    repo: str | None = None
    json_fields: str | None = Field(default=None, alias="json")
    jq: str | None = None
    template: str | None = None
    web: bool = False
