class Bzr < Formula
  desc "CLI for Bugzilla, inspired by gh"
  homepage "https://github.com/randomparity/bzr"
  license "MIT"
  version "0.4.2"

  on_macos do
    on_arm do
      url "https://github.com/randomparity/bzr/releases/download/v0.4.2/bzr-v0.4.2-aarch64-apple-darwin.tar.gz"
      sha256 "1266a3bc2dcd5b4ddb1781de6a078493f19c4d96941764338275ec8f90f62807"
    end
    on_intel do
      # No prebuilt Intel macOS binary — fall back to a source build.
      url "https://github.com/randomparity/bzr/archive/refs/tags/v0.4.2.tar.gz"
      sha256 "d05d71d0818efc387568df10b378390b13a3ad7b0446a2c9f3ff09451df98138"
      depends_on "rust" => :build
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/randomparity/bzr/releases/download/v0.4.2/bzr-v0.4.2-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "82e6177f0a5943e1da3bd8f8fe9a30fa203c3cf85935dcc96b04467e14ad2903"
    end
    on_intel do
      url "https://github.com/randomparity/bzr/releases/download/v0.4.2/bzr-v0.4.2-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "ce6ed993a678fb628f110570b20ac0f46534770e74445e80cefec5010810d902"
    end
  end

  def install
    if OS.mac? && Hardware::CPU.intel?
      ENV["CARGO_TARGET_DIR"] = buildpath/"target"
      system "cargo", "install", "--locked", "--root", prefix, "--path", "."
      system "cargo", "run", "-p", "xtask", "--no-default-features", "--release", "--",
             "man", "--out", "#{buildpath}/man/man1"
      man1.install Dir["#{buildpath}/man/man1/*.1"]
    else
      bin.install "bzr"
      man1.install Dir["man/man1/*.1"]
    end
  end

  test do
    assert_match "bzr", shell_output("#{bin}/bzr --version")
  end
end
