# crestai-labs/homebrew-tap

The Homebrew tap of [Feld](https://github.com/crestai-labs/feld), the Agent Loop Control Plane. The `feld` formula installs the `feld` executable and its bundled Plugins from the GitHub Release archives.

## Install

```sh
brew install crestai-labs/tap/feld
```

Upgrade with `brew upgrade feld` and remove with `brew uninstall feld`. After installing or upgrading, run `feld init` as the [Feld README](https://github.com/crestai-labs/feld#install) describes.

Supported platforms: macOS on Apple Silicon, and Linux on x86_64 (glibc 2.35 or later). Homebrew reports other platforms as unsupported.

## Maintaining the formula

When Feld releases `vX.Y.Z`, run `scripts/update.sh X.Y.Z`, which downloads the Release checksums and rewrites the formula, then commit it as `feld X.Y.Z` and push.
