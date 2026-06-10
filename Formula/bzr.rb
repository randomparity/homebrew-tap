class Bzr < Formula
  desc "CLI for Bugzilla, inspired by gh"
  homepage "https://github.com/randomparity/bzr"
  license "MIT"
  version "0.4.3"

  on_macos do
    on_arm do
      url "https://github.com/randomparity/bzr/releases/download/v0.4.3/bzr-v0.4.3-aarch64-apple-darwin.tar.gz"
      sha256 "727f28e643997b6569f9d5d811043409b8299c5e67e22ba7907c205e64868a31"
    end
    on_intel do
      # No prebuilt Intel macOS binary — fall back to a source build.
      url "https://github.com/randomparity/bzr/archive/refs/tags/v0.4.3.tar.gz"
      sha256 "8074ef11d8ea58dd60e655c7f63efdb1deb680f41319dab80ba056b67b9b5d13"
      depends_on "rust" => :build
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/randomparity/bzr/releases/download/v0.4.3/bzr-v0.4.3-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "7c6ad05a798f74327aefe7665b0534e4accce9ac00b8340fe54ffc546d36ed4f"
    end
    on_intel do
      url "https://github.com/randomparity/bzr/releases/download/v0.4.3/bzr-v0.4.3-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "81710db968fa3450bb810f3f0732dc0f20b12ac93dfb462bb726a13127675289"
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
