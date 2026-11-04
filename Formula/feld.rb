class Feld < Formula
  desc "Agent Loop Control Plane"
  homepage "https://github.com/crestai-labs/feld"
  license "Apache-2.0"

  depends_on "tmux"

  on_macos do
    on_arm do
      url "https://github.com/crestai-labs/feld/releases/download/v0.2.1/feld-v0.2.1-aarch64-apple-darwin.tar.gz"
      sha256 "6ebb2ae2ef188bd06c736291ef5e6438913052e2abe9c34afce37c1cbb986fa8"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/crestai-labs/feld/releases/download/v0.2.1/feld-v0.2.1-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "b7061fb5cfdf5939fff6e7ff523cbf252ec5dc36a04ec24339e7b0a5e1f4a9ae"
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
