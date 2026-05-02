class Bzr < Formula
  desc "CLI for Bugzilla, inspired by gh"
  homepage "https://github.com/randomparity/bzr"
  license "MIT"
  version "0.2.0-rc3"

  on_macos do
    on_arm do
      url "https://github.com/randomparity/bzr/releases/download/v0.2.0-rc3/bzr-v0.2.0-rc3-aarch64-apple-darwin.tar.gz"
      sha256 "81d61eb7659fd80180008f6cb3f6460aba5d0eaa5b41f2b0f2f2f6f8172c6b43"
    end
    on_intel do
      # No prebuilt Intel macOS binary — fall back to a source build.
      url "https://github.com/randomparity/bzr/archive/refs/tags/v0.2.0-rc3.tar.gz"
      sha256 "ad966f010a7ba4a0d82fa325f21047d81ade438002720f3ea24a2c27abf4f3fa"
      depends_on "rust" => :build
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/randomparity/bzr/releases/download/v0.2.0-rc3/bzr-v0.2.0-rc3-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "b5579341881d78074e012d2613ae636e10fdcb0bf11d35bba093b4dc8e7a6cba"
    end
    on_intel do
      url "https://github.com/randomparity/bzr/releases/download/v0.2.0-rc3/bzr-v0.2.0-rc3-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "9a9331865daf6966c4e322b6145d849a0934d06930869df6489ed832e40cca55"
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
