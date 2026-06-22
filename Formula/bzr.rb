class Bzr < Formula
  desc "CLI for Bugzilla, inspired by gh"
  homepage "https://github.com/randomparity/bzr"
  license "MIT"
  version "0.6.0"

  on_macos do
    on_arm do
      url "https://github.com/randomparity/bzr/releases/download/v0.6.0/bzr-v0.6.0-aarch64-apple-darwin.tar.gz"
      sha256 "928ebe40ea3b5dc1fdd18cb78ea4a73e80bb2f624e4d74c2f3ceb2d515edcea0"
    end
    on_intel do
      # No prebuilt Intel macOS binary — fall back to a source build.
      url "https://github.com/randomparity/bzr/archive/refs/tags/v0.6.0.tar.gz"
      sha256 "d42f129954cce6f05476c6bd5a4a153135310fe83037bb2a2e03392a5229c04f"
      depends_on "rust" => :build
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/randomparity/bzr/releases/download/v0.6.0/bzr-v0.6.0-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "ff9950ae73e2f4e651e0b46bc6009fbd8869206bc849571cb20199a0d7031c76"
    end
    on_intel do
      url "https://github.com/randomparity/bzr/releases/download/v0.6.0/bzr-v0.6.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "818246afbb6e19a06db45f0aeec9524d2497cc803232e92bc588b10e90e82676"
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
