class Bzr < Formula
  desc "CLI for Bugzilla, inspired by gh"
  homepage "https://github.com/randomparity/bzr"
  license "MIT"
  version "0.10.1"

  on_macos do
    on_arm do
      url "https://github.com/randomparity/bzr/releases/download/v0.10.1/bzr-v0.10.1-aarch64-apple-darwin.tar.gz"
      sha256 "75354512d26403d389d79e7e2c7cf219ae9894aa00699d3684a370cca58f2a62"
    end
    on_intel do
      # No prebuilt Intel macOS binary — fall back to a source build.
      url "https://github.com/randomparity/bzr/archive/refs/tags/v0.10.1.tar.gz"
      sha256 "0751f707695e904dd160f1b239f5160f9a100a39b10597c19e17958a108e4562"
      depends_on "rust" => :build
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/randomparity/bzr/releases/download/v0.10.1/bzr-v0.10.1-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "a0a0a3956b50e6a47fc528a46681e29ec9d4705e7186a67e899fc504907ec040"
    end
    on_intel do
      url "https://github.com/randomparity/bzr/releases/download/v0.10.1/bzr-v0.10.1-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "53cfede4798f0a884d0b0a15b37446e5cc19f74fe1bc5ea84e2ed44f8cb01bc6"
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
