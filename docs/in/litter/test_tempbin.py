import gzip
import subprocess
import tempfile
import unittest
from contextlib import chdir, redirect_stdout
from io import StringIO
from pathlib import Path
from unittest import mock
from zipfile import ZipFile

import list_bin_versions
import organize_tempbin


class TestTempbin(unittest.TestCase):
    """
    Exercise organization and version reporting in isolated directories.
    """

    def setUp(self) -> None:
        self.root = Path(self.enterContext(tempfile.TemporaryDirectory()))

    def _executable(self, name: str, content: str) -> Path:
        path = self.root / name
        path.write_text(content, encoding="utf-8")
        path.chmod(0o755)
        return path

    def test_empty_directory(self) -> None:
        organize_tempbin.organize(self.root)
        self.assertEqual(list(self.root.rglob("*")), [])

    def test_loose_executable_is_normalized(self) -> None:
        source = self._executable("tool-linux-amd64", "#!/bin/sh\necho tool\n")
        organize_tempbin.organize(self.root)
        destination = self.root / "bin" / "tool"
        self.assertEqual(destination.read_text(), "#!/bin/sh\necho tool\n")
        self.assertTrue(destination.stat().st_mode & 0o111)
        self.assertFalse(source.exists())

    def test_archive_manpage_completions_and_documentation(self) -> None:
        archive = self.root / "tool.zip"
        manpage = b".TH TOOL 1\n.SH NAME\ntool - example\n"
        with ZipFile(archive, "w") as bundle:
            bundle.writestr("tool-linux-amd64", b"\x7fELFtool")
            bundle.writestr("doc/tool.1.gz", gzip.compress(manpage))
            bundle.writestr("completions/tool.bash", "complete -W help tool\n")
            bundle.writestr("completions/tool.fish", "complete -c tool\n")
            bundle.writestr("README.md", "documentation")
            bundle.writestr("LICENSE", "license")
            bundle.writestr("data.txt", "not an executable")
        (self.root / "README.md").write_text("loose documentation")
        organize_tempbin.organize(self.root)
        self.assertEqual(
            (self.root / "bin" / "tool").read_bytes(), b"\x7fELFtool"
        )
        self.assertEqual((self.root / "man" / "tool.1").read_bytes(), manpage)
        self.assertEqual(
            (self.root / "completions" / "tool.bash").read_text(),
            "complete -W help tool\n",
        )
        self.assertEqual(
            (self.root / "completions" / "tool.fish").read_text(),
            "complete -c tool\n",
        )
        self.assertEqual(
            {
                path.relative_to(self.root).as_posix()
                for path in self.root.rglob("*")
                if path.is_file()
            },
            {
                "bin/tool",
                "man/tool.1",
                "completions/tool.bash",
                "completions/tool.fish",
            },
        )

    def test_archive_collision_preserves_destination_and_archive(self) -> None:
        destination = self.root / "bin" / "tool"
        destination.parent.mkdir()
        destination.write_bytes(b"original")
        archive = self.root / "tool.zip"
        with ZipFile(archive, "w") as bundle:
            bundle.writestr("tool-linux-amd64", b"\x7fELFreplacement")
        original_archive = archive.read_bytes()
        with self.assertRaises(FileExistsError):
            organize_tempbin.organize(self.root)
        self.assertEqual(destination.read_bytes(), b"original")
        self.assertTrue(archive.exists(), "collision must retain the archive")
        self.assertEqual(archive.read_bytes(), original_archive)

    def test_loose_collision_retains_source(self) -> None:
        destination = self.root / "bin" / "tool"
        destination.parent.mkdir()
        destination.write_text("original")
        source = self._executable("tool-linux-amd64", "replacement")
        with self.assertRaises(FileExistsError):
            organize_tempbin.organize(self.root)
        self.assertEqual(destination.read_text(), "original")
        self.assertTrue(
            source.exists(), "collision must retain the loose binary"
        )
        self.assertEqual(source.read_text(), "replacement")

    def test_version_first_line_preserves_literal_brackets(self) -> None:
        self._executable(
            "tool",
            "#!/bin/sh\nprintf 'tool [bold]stable[/bold] 1.2\\nsecond line\\n'\n",
        )
        output = StringIO()
        with redirect_stdout(output):
            list_bin_versions.list_versions(self.root)
        self.assertEqual(
            output.getvalue().strip(), "tool: tool [bold]stable[/bold] 1.2"
        )

    def test_empty_failing_version_falls_back_to_help(self) -> None:
        binary = self._executable("tool", "#!/bin/sh\n")
        results = [
            subprocess.CompletedProcess([str(binary), "--version"], 1, "", ""),
            subprocess.CompletedProcess(
                [str(binary), "--help"], 0, "", "tool help\nusage details\n"
            ),
        ]
        output = StringIO()
        with (
            mock.patch.object(
                list_bin_versions.subprocess, "run", side_effect=results
            ) as run,
            redirect_stdout(output),
        ):
            list_bin_versions.list_versions(self.root)
        self.assertEqual(
            [call.args[0][1] for call in run.call_args_list],
            ["--version", "--help"],
        )
        self.assertEqual(output.getvalue().strip(), "tool: tool help")

    def test_execution_errors_do_not_stop_remaining_binaries(self) -> None:
        self._executable("broken", "#!/bin/sh\n")
        self._executable("working", "#!/bin/sh\n")
        errors = [
            OSError("cannot execute tool"),
            subprocess.TimeoutExpired("tool", 5),
        ]
        for error in errors:
            with self.subTest(error=type(error).__name__):
                output = StringIO()
                result = subprocess.CompletedProcess(
                    ["working", "--version"], 0, "working 1.0\n", ""
                )
                with (
                    mock.patch.object(
                        list_bin_versions.subprocess,
                        "run",
                        side_effect=[error, result],
                    ),
                    redirect_stdout(output),
                ):
                    list_bin_versions.list_versions(self.root)
                self.assertIn("broken:", output.getvalue())
                self.assertIn(str(error).splitlines()[0], output.getvalue())
                self.assertIn("working: working 1.0", output.getvalue())

    def test_relative_directory_executes_absolute_binary_path(self) -> None:
        self._executable("tool", "#!/bin/sh\nprintf 'relative 1.0\\n'\n")
        output = StringIO()
        with (
            chdir(self.root.parent),
            mock.patch.object(
                list_bin_versions.subprocess, "run", wraps=subprocess.run
            ) as run,
            redirect_stdout(output),
        ):
            list_bin_versions.list_versions(Path(self.root.name))
        self.assertTrue(Path(run.call_args.args[0][0]).is_absolute())
        self.assertEqual(output.getvalue().strip(), "tool: relative 1.0")


if __name__ == "__main__":
    unittest.main()
