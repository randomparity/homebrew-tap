class Bzr < Formula
  desc "CLI for Bugzilla, inspired by gh"
  homepage "https://github.com/randomparity/bzr"
  license "MIT"
  version "0.4.4"

  on_macos do
    on_arm do
      url "https://github.com/randomparity/bzr/releases/download/v0.4.4/bzr-v0.4.4-aarch64-apple-darwin.tar.gz"
      sha256 "39bd262bddbec8e72a383443c6f66cf230e98899a9749b1ca9a0d2cd933b1bc3"
    end
    on_intel do
      # No prebuilt Intel macOS binary — fall back to a source build.
      url "https://github.com/randomparity/bzr/archive/refs/tags/v0.4.4.tar.gz"
      sha256 "b3cf01a075cef8241ff3898c563fb3ef80001775d6073ceb11d08e43663b74b9"
      depends_on "rust" => :build
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/randomparity/bzr/releases/download/v0.4.4/bzr-v0.4.4-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "66f75a547909302139ff1bf2dde7b1e0a340e2930b12fd92eebf1a0161111c34"
    end
    on_intel do
      url "https://github.com/randomparity/bzr/releases/download/v0.4.4/bzr-v0.4.4-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "3a07659b1363a44f147c9778fe3160d8668169d972aef266db46a91d1be2abc3"
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
