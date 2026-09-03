class Bzr < Formula
  desc "CLI for Bugzilla, inspired by gh"
  homepage "https://github.com/randomparity/bzr"
  license "MIT"
  version "0.9.0"

  on_macos do
    on_arm do
      url "https://github.com/randomparity/bzr/releases/download/v0.9.0/bzr-v0.9.0-aarch64-apple-darwin.tar.gz"
      sha256 "b40b7db71f30a3b215fc09737c7430a7ec8e8906e3cdcceefae31f1773adf165"
    end
    on_intel do
      # No prebuilt Intel macOS binary — fall back to a source build.
      url "https://github.com/randomparity/bzr/archive/refs/tags/v0.9.0.tar.gz"
      sha256 "9023419f6e9fcb2702c3aebfe45b9590937ae24cf38703070be335746c7369e4"
      depends_on "rust" => :build
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/randomparity/bzr/releases/download/v0.9.0/bzr-v0.9.0-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "f41f2cee17822eb98990db8c76bd4de9bc8334beb5a1a989b8512336cc8541fe"
    end
    on_intel do
      url "https://github.com/randomparity/bzr/releases/download/v0.9.0/bzr-v0.9.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "66398b8df6983ae3c79c0e2bb55e52e5a4d8995e815f93e5e4b268142010e988"
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
