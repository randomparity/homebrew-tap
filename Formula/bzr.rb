class Bzr < Formula
  desc "CLI for Bugzilla, inspired by gh"
  homepage "https://github.com/randomparity/bzr"
  license "MIT"
  version "0.5.0"

  bottle do
    root_url "https://github.com/randomparity/bzr/releases/download/v0.5.0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma: "99b05f25b3d02fa10aad80163e13f2876adc26a728ecadb9b459457814478d68"
    sha256 cellar: :any_skip_relocation, arm64_linux:  "c80a71c3a20622418315ebdecac06723f9ba7993671fe38b0ddae0b6d4bb1850"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "dbd9e74d4239e450a67aed3f5d6674a710c403b6f99c7806d9066362ac6e7fc2"
  end

  on_macos do
    on_arm do
      url "https://github.com/randomparity/bzr/releases/download/v0.5.0/bzr-v0.5.0-aarch64-apple-darwin.tar.gz"
      sha256 "a9cba945ca3570ec179e00fcb952b3eb7076233b47fbc497a138ef7564fc000b"
    end
    on_intel do
      # No prebuilt Intel macOS binary — fall back to a source build.
      url "https://github.com/randomparity/bzr/archive/refs/tags/v0.5.0.tar.gz"
      sha256 "71d30140a355a9dcc94b5395e685084b15ffdf1ca4f04e78b877f18f996fd7b7"
      depends_on "rust" => :build
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/randomparity/bzr/releases/download/v0.5.0/bzr-v0.5.0-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "3a930050dabaa923f68032ab4d76fcbc4ea492aaf323c8f7f465b10a87fb03c1"
    end
    on_intel do
      url "https://github.com/randomparity/bzr/releases/download/v0.5.0/bzr-v0.5.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "e311db67f32b4cf47ac58eb813c7cd1ef15443d024d688869e18cbe1d91a26f8"
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
