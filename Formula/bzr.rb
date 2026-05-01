class Bzr < Formula
  desc "CLI for Bugzilla, inspired by gh"
  homepage "https://github.com/randomparity/bzr"
  license "MIT"
  version "0.2.0-rc2"

  on_macos do
    on_arm do
      url "https://github.com/randomparity/bzr/releases/download/v0.2.0-rc2/bzr-v0.2.0-rc2-aarch64-apple-darwin.tar.gz"
      sha256 "9af0a4d8254566ccdbad5a586e965ba162b99fa6e54a736137bc813077e22fe8"
    end
    on_intel do
      # No prebuilt Intel macOS binary — fall back to a source build.
      url "https://github.com/randomparity/bzr/archive/refs/tags/v0.2.0-rc2.tar.gz"
      sha256 "4663127f06a962b14f55644bcc090d134bef03b1ab5a5d12d26267e04925fde5"
      depends_on "rust" => :build
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/randomparity/bzr/releases/download/v0.2.0-rc2/bzr-v0.2.0-rc2-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "513be9a084c4ca4ff8522e1f55861e298c17ea914d0f745d8421ed048901b504"
    end
    on_intel do
      url "https://github.com/randomparity/bzr/releases/download/v0.2.0-rc2/bzr-v0.2.0-rc2-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "fa031a5dabc2784faca808a7e585b18f7e835ffd52a5f2715bf3b3aeea2e7b46"
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
