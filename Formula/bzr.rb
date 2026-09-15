class Bzr < Formula
  desc "CLI for Bugzilla, inspired by gh"
  homepage "https://github.com/randomparity/bzr"
  license "MIT"
  version "0.10.0"

  bottle do
    root_url "https://github.com/randomparity/bzr/releases/download/v0.10.0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma: "67a819b1f27f8d72b5fd257cc7c6cedbcd77a1f04998489db8ef5cbc0f16a83f"
    sha256 cellar: :any_skip_relocation, arm64_linux:  "7a5bd17d1af5cd8465aea5c383d815148694fd6b6520367f28a52d572e8ee2f3"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "dd1d8db313c16f318bd0132a58e4503bea39b227aea9a224d4fadd07a2b01a0d"
  end

  on_macos do
    on_arm do
      url "https://github.com/randomparity/bzr/releases/download/v0.10.0/bzr-v0.10.0-aarch64-apple-darwin.tar.gz"
      sha256 "715c09337ccc38f6363c17f3d3c89183b6dd7631dca664d010cb24a8bc7d2cc2"
    end
    on_intel do
      # No prebuilt Intel macOS binary — fall back to a source build.
      url "https://github.com/randomparity/bzr/archive/refs/tags/v0.10.0.tar.gz"
      sha256 "e2a546e771f885256ab7914c3af521e9b78649b6b84dd47cababff7ac3e15b43"
      depends_on "rust" => :build
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/randomparity/bzr/releases/download/v0.10.0/bzr-v0.10.0-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "ebd5e68efac9e356abc8aab0ab620afd26f6cf5dc99982305a20bdc1dcc24dbf"
    end
    on_intel do
      url "https://github.com/randomparity/bzr/releases/download/v0.10.0/bzr-v0.10.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "61138239c4ff779843c3ebf480842d6548b089d00f702afb7e7c2c5333464750"
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
