class Bzr < Formula
  desc "CLI for Bugzilla, inspired by gh"
  homepage "https://github.com/randomparity/bzr"
  license "MIT"
  version "0.4.1"

  on_macos do
    on_arm do
      url "https://github.com/randomparity/bzr/releases/download/v0.4.1/bzr-v0.4.1-aarch64-apple-darwin.tar.gz"
      sha256 "7ae7392e87acb8a22029212fac72c2eeba31cd14af1812ec4f710b5a8c5af28a"
    end
    on_intel do
      # No prebuilt Intel macOS binary — fall back to a source build.
      url "https://github.com/randomparity/bzr/archive/refs/tags/v0.4.1.tar.gz"
      sha256 "1b395fceab8eedfd66a52c5cdfba60d1af23bc9ea02931e60d6fcf88a937303b"
      depends_on "rust" => :build
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/randomparity/bzr/releases/download/v0.4.1/bzr-v0.4.1-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "0335563c0a11f5ccaab2db05b733a18df01ffffb4484f61b219c9af38db65afa"
    end
    on_intel do
      url "https://github.com/randomparity/bzr/releases/download/v0.4.1/bzr-v0.4.1-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "d054a4853d14cc97407b0fb242816dc56557f15370b44ffcc645ef008a8833a9"
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
