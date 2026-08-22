class RustyImapMcp < Formula
  desc "Security-first MCP server for IMAP email access"
  homepage "https://github.com/randomparity/rusty-imap-mcp"
  license any_of: ["MIT", "Apache-2.0"]
  version "0.2.0"

  on_macos do
    on_arm do
      url "https://github.com/randomparity/rusty-imap-mcp/releases/download/v0.2.0/rusty-imap-mcp-v0.2.0-aarch64-apple-darwin.tar.gz"
      sha256 "c4386cae60a29844e532fe077e480c2c5e8ae6c66780bfefa387012489a43c12"
    end
    on_intel do
      # No prebuilt Intel macOS binary — fall back to a source build.
      url "https://github.com/randomparity/rusty-imap-mcp/archive/refs/tags/v0.2.0.tar.gz"
      sha256 "9d50e5f9b2a2662dff28c053dd6e52aa4b4399ad50ba69c19e1349e300639c0d"
      depends_on "rust" => :build
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/randomparity/rusty-imap-mcp/releases/download/v0.2.0/rusty-imap-mcp-v0.2.0-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "43a74a665aa17cccd0e0d7e9142785b3dc7e4156d50f9f2c7f01a79c66bb765f"
    end
    on_intel do
      url "https://github.com/randomparity/rusty-imap-mcp/releases/download/v0.2.0/rusty-imap-mcp-v0.2.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "7cde1d6ab6de2ed2aa95bc1459454510311d96b6015fe2d0f6c81b30bfe512c9"
    end
  end

  def install
    if OS.mac? && Hardware::CPU.intel?
      ENV["CARGO_TARGET_DIR"] = buildpath/"target"
      system "cargo", "install", "--locked", "--root", prefix, "--path", "crates/rimap-server"
    else
      bin.install "rusty-imap-mcp"
      # Binary/bottle tarballs ship manpages under share/man/man1 (#545). The
      # Intel-mac source build above has no generated pages; --help covers it.
      man1.install Dir["share/man/man1/*.1"] if Dir.exist?("share/man/man1")
    end
  end

  test do
    assert_match "rusty-imap-mcp", shell_output("#{bin}/rusty-imap-mcp --version")
  end
end
