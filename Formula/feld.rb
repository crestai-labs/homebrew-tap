class Feld < Formula
  desc "Agent Loop Control Plane"
  homepage "https://github.com/crestai-labs/feld"
  license "Apache-2.0"

  depends_on "tmux"

  on_macos do
    on_arm do
      url "https://github.com/crestai-labs/feld/releases/download/v0.3.0/feld-v0.3.0-aarch64-apple-darwin.tar.gz"
      sha256 "a1e3ce663ddaf05a657f31e78e309fce69305a0c5d1276330c38ff0f1d445a0f"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/crestai-labs/feld/releases/download/v0.3.0/feld-v0.3.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "d57d0e23be2e3b698749940c303f966122be9985d89921facda5afdc930ebe3d"
    end
  end

  def install
    # `feld` looks for the `feld-plugin-*` executables beside its own, so all of them go to bin.
    bin.install "feld"
    bin.install Dir["feld-plugin-*"]
    prefix.install "LICENSE", "NOTICE", "THIRD-PARTY-LICENSES.md"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/feld --version")
  end
end
