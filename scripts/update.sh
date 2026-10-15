#!/bin/sh
# Point Formula/feld.rb at Release vX.Y.Z of crestai-labs/feld.
#
#   scripts/update.sh X.Y.Z
#
# Downloads the `.sha256` file of each archive the formula installs, rewrites every
# `url` / `sha256` in the formula (and `version`, when the formula sets one), and prints
# the resulting diff. Running it
# again for the same version changes nothing. A Release without one of the checksum
# files stops the script before the formula is touched.

set -eu

repo=crestai-labs/feld
targets="aarch64-apple-darwin x86_64-unknown-linux-gnu"

fail() {
  echo "update.sh: $*" >&2
  exit 1
}

[ $# -eq 1 ] || fail "usage: scripts/update.sh X.Y.Z"
version=${1#v}
echo "$version" | grep -Eq '^[0-9]+\.[0-9]+\.[0-9]+$' || fail "'$1' is not a version of the form X.Y.Z"
command -v curl >/dev/null 2>&1 || fail "curl is required"

root=$(cd "$(dirname "$0")/.." && pwd)
formula=$root/Formula/feld.rb
[ -f "$formula" ] || fail "$formula is missing"

tmp=$(mktemp -d)
trap 'rm -rf "$tmp"' EXIT

# The sha256 of the archive for one target, read from the `.sha256` file next to it on
# the Release, whose line is `<sha256>  <archive name>`.
checksum() {
  name=feld-v$version-$1.tar.gz
  url=https://github.com/$repo/releases/download/v$version/$name.sha256
  curl -fsSL -o "$tmp/$name.sha256" "$url" || fail "cannot download $url; does Release v$version have $name.sha256?"
  sum=$(sed -n "s/^\([0-9a-f]\{64\}\)[[:space:]]\{1,\}$name\$/\1/p" "$tmp/$name.sha256")
  [ -n "$sum" ] || fail "$name.sha256 does not hold a sha256 of $name"
  echo "$sum"
}

mac=$(checksum aarch64-apple-darwin)
linux=$(checksum x86_64-unknown-linux-gnu)

# Rewrite each `url` together with the `sha256` that follows it, and `version` when the
# formula sets one (Homebrew reads the version from the url otherwise). The target of a
# `url` is read from its archive name, so the order of the blocks in the formula does not
# matter.
awk -v version="$version" -v repo="$repo" -v mac="$mac" -v linux="$linux" '
  function fail(message) {
    print "update.sh: " message > "/dev/stderr"
    exit 1
  }
  /^[[:space:]]*version "/ {
    sub(/"[^"]*"/, "\"" version "\"")
    versions++
  }
  /^[[:space:]]*url "/ {
    if (index($0, "-aarch64-apple-darwin.tar.gz")) { target = "aarch64-apple-darwin"; sum = mac }
    else if (index($0, "-x86_64-unknown-linux-gnu.tar.gz")) { target = "x86_64-unknown-linux-gnu"; sum = linux }
    else fail("unknown archive in: " $0)
    sub(/"[^"]*"/, "\"https://github.com/" repo "/releases/download/v" version "/feld-v" version "-" target ".tar.gz\"")
    urls++
  }
  /^[[:space:]]*sha256 "/ {
    if (sum == "") fail("sha256 without a url before it: " $0)
    sub(/"[^"]*"/, "\"" sum "\"")
    sum = ""
    sums++
  }
  { print }
  END {
    if (versions > 1) fail("expected at most one version line, found " versions)
    if (urls != 2 || sums != 2) fail("expected two url and two sha256 lines, found " urls + 0 " and " sums + 0)
  }
' "$formula" >"$tmp/feld.rb"

if cmp -s "$tmp/feld.rb" "$formula"; then
  echo "Formula/feld.rb already points at v$version"
  exit 0
fi
mv "$tmp/feld.rb" "$formula"
echo "Formula/feld.rb now points at v$version"
git -C "$root" --no-pager diff -- Formula/feld.rb
