class Bzr < Formula
  desc "CLI for Bugzilla, inspired by gh"
  homepage "https://github.com/randomparity/bzr"
  license "MIT"
  version "0.8.0"

  on_macos do
    on_arm do
      url "https://github.com/randomparity/bzr/releases/download/v0.8.0/bzr-v0.8.0-aarch64-apple-darwin.tar.gz"
      sha256 "43635ed533f85479b8a5b17cc2a63adeaaead3f2acf39981aa37a7719d5f3582"
    end
    on_intel do
      # No prebuilt Intel macOS binary — fall back to a source build.
      url "https://github.com/randomparity/bzr/archive/refs/tags/v0.8.0.tar.gz"
      sha256 "cd906b8ddfb9002c955bf5a9402f2047c29b6cedd762a06585fa697d85455018"
      depends_on "rust" => :build
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/randomparity/bzr/releases/download/v0.8.0/bzr-v0.8.0-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "0b07de8239b8eb95241347e78bb6831df1d37a0736ce6969056488824794179b"
    end
    on_intel do
      url "https://github.com/randomparity/bzr/releases/download/v0.8.0/bzr-v0.8.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "41214d14607cbd2c6ee458b637c49f2beef846e39ed4961549d8ee8da5fc5186"
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
