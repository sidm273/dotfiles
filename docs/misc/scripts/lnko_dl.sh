#!/bin/sh
# Description: download -> verify -> install binary.
# Exit on unhandled command failures and unset variable expansions.
set -o errexit -o nounset
# Resolve script dir path for checksum validation.
script_dir=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
download_dir=$(mktemp -d)
# always cleanup.
trap 'rm --recursive --force -- "$download_dir"' EXIT
# binary specific info.
program="lnko"
binary="$program-linux_x86_64"
repo="Owloops/lnko"
version="v0.6.0"
install_dir="${HOME}/.local/bin"
checksum_path="$script_dir/checksum.sha256"

mkdir -p "$install_dir"
# gh release download "$version" --repo "$repo" --pattern "$binary" --dir "$download_dir"
curl --fail --silent --show-error --location --output "$download_dir/$binary" "https://github.com/$repo/releases/download/$version/$binary"

(cd "$download_dir" && sha256sum --check "$checksum_path") || {
    echo "ERROR: SHA-256 verification failed." >&2
    exit 1
}

install --mode=u=rwx,go=rx "$download_dir/$binary" "$install_dir/$program"
