class Feld < Formula
  desc "Agent Loop Control Plane"
  homepage "https://github.com/crestai-labs/feld"
  license "Apache-2.0"

  depends_on "tmux"

  on_macos do
    on_arm do
      url "https://github.com/crestai-labs/feld/releases/download/v0.2.0/feld-v0.2.0-aarch64-apple-darwin.tar.gz"
      sha256 "09f57e2db6b14fe1ccdfff4f1b7a9cf00a90532eaf938b7ca5b5db2f54367874"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/crestai-labs/feld/releases/download/v0.2.0/feld-v0.2.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "1f41082c7eb479057fbddadcd00e4236ab6eccfc7985e12a7ab94467d24c7927"
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
