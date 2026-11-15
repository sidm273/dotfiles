#!/bin/sh
# Description: download -> verify -> install binary.
# Exit on unhandled command failures and unset variable expansions.
set -o errexit -o nounset
# Resolve script dir path for checksum validation.
script_dir=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
tmp_dir=$(mktemp -d)
# always cleanup.
trap 'rm -rf "$tmp_dir"' EXIT
# binary specific info.
program="lnko"
binary="$program-linux_x86_64"
repo="Owloops/lnko"
version="v0.6.0"
install_dir="${HOME}/.local/bin"
checksum_path="$script_dir/checksum.sha256"

mkdir -p "$install_dir"
gh release download "$version" --repo "$repo" --pattern "$binary" --dir "$tmp_dir"

(cd "$tmp_dir" && sha256sum --check "$checksum_path") || {
    echo "ERROR: SHA-256 verification failed." >&2
    exit 1
}

install --mode=u=rwx,go=rx "$tmp_dir/$binary" "$install_dir/$program"
