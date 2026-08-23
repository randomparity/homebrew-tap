class Bzr < Formula
  desc "CLI for Bugzilla, inspired by gh"
  homepage "https://github.com/randomparity/bzr"
  license "MIT"
  version "0.8.2"

  bottle do
    root_url "https://github.com/randomparity/bzr/releases/download/v0.8.2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma: "8ba847a95cbd94ce6e91810176f0d7b611b642ef558e1bc44441b76ff69ee3dd"
    sha256 cellar: :any_skip_relocation, arm64_linux:  "ed989e46d6802dceab79d859b2c5b530cbfaf1bcff5f7e63718039916b6462e0"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "555701bb7add0f95e4cb7b9d530377fcc086717697a210d8c8bc1ecbd53beb98"
  end

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
