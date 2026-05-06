class Bzr < Formula
  desc "CLI for Bugzilla, inspired by gh"
  homepage "https://github.com/randomparity/bzr"
  license "MIT"
  version "0.3.0"

  on_macos do
    on_arm do
      url "https://github.com/randomparity/bzr/releases/download/v0.3.0/bzr-v0.3.0-aarch64-apple-darwin.tar.gz"
      sha256 "c562c520849ea6e41ea180ceec24c2ef245752ff7a76fe5816302ffed9f7a7c8"
    end
    on_intel do
      # No prebuilt Intel macOS binary — fall back to a source build.
      url "https://github.com/randomparity/bzr/archive/refs/tags/v0.3.0.tar.gz"
      sha256 "58a15902ae11edb66f4e9d0aa4c7c5a03dfc98e1af05989ce8ec922107ff75f6"
      depends_on "rust" => :build
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/randomparity/bzr/releases/download/v0.3.0/bzr-v0.3.0-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "fd51d0ed20363659959c04e46b302e009bb14d8d00bf8e022ca546a6ec612f28"
    end
    on_intel do
      url "https://github.com/randomparity/bzr/releases/download/v0.3.0/bzr-v0.3.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "a69d3f0c6c99d84af2b64ebeba96fd9b7f01a868526d9a18cb69afcd33d3ec4b"
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
