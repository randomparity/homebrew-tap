class Bzr < Formula
  desc "CLI for Bugzilla, inspired by gh"
  homepage "https://github.com/randomparity/bzr"
  license "MIT"
  version "0.7.0"

  on_macos do
    on_arm do
      url "https://github.com/randomparity/bzr/releases/download/v0.7.0/bzr-v0.7.0-aarch64-apple-darwin.tar.gz"
      sha256 "fa67bd759bad4cb4b6f6f7dafb276cc3d2a1e254cfa1dd45f1dea637dd6e192c"
    end
    on_intel do
      # No prebuilt Intel macOS binary — fall back to a source build.
      url "https://github.com/randomparity/bzr/archive/refs/tags/v0.7.0.tar.gz"
      sha256 "62d57b9821f9290b4c3635f3e18642f69e039bb124cda5d66034d0f00f528b02"
      depends_on "rust" => :build
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/randomparity/bzr/releases/download/v0.7.0/bzr-v0.7.0-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "5ad1d694aac72190779c1f0296d96819614d312eb5affcf7ca57a949a246c093"
    end
    on_intel do
      url "https://github.com/randomparity/bzr/releases/download/v0.7.0/bzr-v0.7.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "af21911960d410d7d0d3cb456afdcddc8d157e60ac82eda00e3908501f0b2cb5"
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
