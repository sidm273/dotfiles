"""Smoke-test argv, validation, and environment overrides without downloading."""

import os

import pytest
from pydantic import ValidationError

from cli_models import GhReleaseDownload, GhReleaseList, GhReleaseView


@pytest.fixture(autouse=True)
def clean_command_environment(monkeypatch: pytest.MonkeyPatch) -> None:
    for name in os.environ:
        if name.startswith(
            ("GH_RELEASE_DOWNLOAD_", "GH_RELEASE_LIST_", "GH_RELEASE_VIEW_")
        ):
            monkeypatch.delenv(name)


def test_download_argv() -> None:
    assert GhReleaseDownload(
        tag="v1", directory="build dir", pattern=["*.deb", "*.rpm"], clobber=True
    ).to_argv() == [
        "gh",
        "release",
        "download",
        "v1",
        "--dir",
        "build dir",
        "--pattern",
        "*.deb",
        "--pattern",
        "*.rpm",
        "--clobber",
    ]


def test_list_argv() -> None:
    assert GhReleaseList(limit=10, json_fields="tagName").to_argv() == [
        "gh",
        "release",
        "list",
        "--limit",
        "10",
        "--json",
        "tagName",
    ]


def test_view_argv() -> None:
    assert GhReleaseView(tag="v1", web=True).to_argv() == [
        "gh",
        "release",
        "view",
        "v1",
        "--web",
    ]


def test_download_rejects_conflicting_destinations() -> None:
    with pytest.raises(ValidationError, match="mutually exclusive"):
        GhReleaseDownload(tag="v1", directory="build", output="asset.deb")


def test_environment_and_explicit_override(monkeypatch: pytest.MonkeyPatch) -> None:
    monkeypatch.setenv("GH_RELEASE_VIEW_REPO", "cli/cli")
    assert GhReleaseView().repo == "cli/cli"
    assert GhReleaseView(repo="other/repo").repo == "other/repo"
