class Bzr < Formula
  desc "CLI for Bugzilla, inspired by gh"
  homepage "https://github.com/randomparity/bzr"
  license "MIT"
  version "0.8.2"

  on_macos do
    on_arm do
      url "https://github.com/randomparity/bzr/releases/download/v0.8.2/bzr-v0.8.2-aarch64-apple-darwin.tar.gz"
      sha256 "4ef47b2cf415055b53037caf19d6b5d1b3c297dc784430bdb0005f48d81772c4"
    end
    on_intel do
      # No prebuilt Intel macOS binary — fall back to a source build.
      url "https://github.com/randomparity/bzr/archive/refs/tags/v0.8.2.tar.gz"
      sha256 "b690dc2f6db680fc4c9006f9b57edb3d3caf62dc68202259903edd00f7cc6f29"
      depends_on "rust" => :build
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/randomparity/bzr/releases/download/v0.8.2/bzr-v0.8.2-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "4b0ad889d6d93c9f9b8f6a03f51cfe5dc98a60938d9938c3b920fef31f8e2a8d"
    end
    on_intel do
      url "https://github.com/randomparity/bzr/releases/download/v0.8.2/bzr-v0.8.2-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "7f6b6bf84ee610a47053cecd5ee2c793279da4a99247a3695731e4d4315c8025"
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
