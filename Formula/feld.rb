class Feld < Formula
  desc "Agent Loop Control Plane"
  homepage "https://github.com/crestai-labs/feld"
  license "Apache-2.0"

  depends_on "tmux"

  on_macos do
    on_arm do
      url "https://github.com/crestai-labs/feld/releases/download/v0.1.0/feld-v0.1.0-aarch64-apple-darwin.tar.gz"
      sha256 "59bffb9d7733a1922274437ab18ee7ad6b171f9e65d24238d5c7bea9a9215d7d"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/crestai-labs/feld/releases/download/v0.1.0/feld-v0.1.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "82a24eca125947a8eb9be885908425aa4d3c773ff2c78484cafecb7b418b1bf3"
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
