class Bzr < Formula
  desc "CLI for Bugzilla, inspired by gh"
  homepage "https://github.com/randomparity/bzr"
  license "MIT"
  version "0.2.0"

  on_macos do
    on_arm do
      url "https://github.com/randomparity/bzr/releases/download/v0.2.0/bzr-v0.2.0-aarch64-apple-darwin.tar.gz"
      sha256 "4256ada2a7a33cab096ea947f1ec6ec4e2c4e107d0170426bf728fe3ba9a6291"
    end
    on_intel do
      # No prebuilt Intel macOS binary — fall back to a source build.
      url "https://github.com/randomparity/bzr/archive/refs/tags/v0.2.0.tar.gz"
      sha256 "3c653b8f1ba43b7a164fe08e895b6b254fbee9aa758f6ee5db60b27269259774"
      depends_on "rust" => :build
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/randomparity/bzr/releases/download/v0.2.0/bzr-v0.2.0-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "f8d6026ce59016e217a4bdf3977e002a0823c95b872b5c5698098fc96c6f31c0"
    end
    on_intel do
      url "https://github.com/randomparity/bzr/releases/download/v0.2.0/bzr-v0.2.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "9c2d97879aa134c473355984905cfd5209de9c12c222809b46bf8857e32943fe"
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
