class Bzr < Formula
  desc "CLI for Bugzilla, inspired by gh"
  homepage "https://github.com/randomparity/bzr"
  license "MIT"
  version "0.4.0"

  on_macos do
    on_arm do
      url "https://github.com/randomparity/bzr/releases/download/v0.4.0/bzr-v0.4.0-aarch64-apple-darwin.tar.gz"
      sha256 "44a377210b0beea5d3093c541fb6568376001ba7ff6377d2665f956c1d0ff5e4"
    end
    on_intel do
      # No prebuilt Intel macOS binary — fall back to a source build.
      url "https://github.com/randomparity/bzr/archive/refs/tags/v0.4.0.tar.gz"
      sha256 "4449295ab63012d4ee789ec7e908dfb4050567fae901a131cd7ad8440a6068d6"
      depends_on "rust" => :build
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/randomparity/bzr/releases/download/v0.4.0/bzr-v0.4.0-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "7a021434e679bddbd8b35410d6beb093abcc9cd7374006615ad35f640e4de4d2"
    end
    on_intel do
      url "https://github.com/randomparity/bzr/releases/download/v0.4.0/bzr-v0.4.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "e29f0dbe764e0099eb08bdbf136628d7a61699e85073aba5365889340f23a7d2"
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
