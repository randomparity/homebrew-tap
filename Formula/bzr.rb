class Bzr < Formula
  desc "CLI for Bugzilla, inspired by gh"
  homepage "https://github.com/randomparity/bzr"
  license "MIT"
  version "0.8.1"

  on_macos do
    on_arm do
      url "https://github.com/randomparity/bzr/releases/download/v0.8.1/bzr-v0.8.1-aarch64-apple-darwin.tar.gz"
      sha256 "caf7ae980aa25bb9f065ab97b07014aecbef96481c9a8216ff20c78ee39c3134"
    end
    on_intel do
      # No prebuilt Intel macOS binary — fall back to a source build.
      url "https://github.com/randomparity/bzr/archive/refs/tags/v0.8.1.tar.gz"
      sha256 "1f98762c2a4a550a14e413e6a5cfa54345eb42c5c0b653a881afe82815d8acf4"
      depends_on "rust" => :build
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/randomparity/bzr/releases/download/v0.8.1/bzr-v0.8.1-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "c7efbe1658ef8b69eb48f1e4348266bc3f83e4129715c15bfabe45c06dc56001"
    end
    on_intel do
      url "https://github.com/randomparity/bzr/releases/download/v0.8.1/bzr-v0.8.1-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "7cc3252c98c9b638668af9a9162ef6bfd67e639c09e39ce60ceaaee18369a50f"
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
