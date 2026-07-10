class RustyImapMcp < Formula
  desc "Security-first MCP server for IMAP email access"
  homepage "https://github.com/randomparity/rusty-imap-mcp"
  license any_of: ["MIT", "Apache-2.0"]
  version "0.1.0"

  on_macos do
    on_arm do
      url "https://github.com/randomparity/rusty-imap-mcp/releases/download/v0.1.0/rusty-imap-mcp-v0.1.0-aarch64-apple-darwin.tar.gz"
      sha256 "3ea19624bda8b466eb9a609725403393f27d2cbbcead1ee18eeb9ed4b85f8843"
    end
    on_intel do
      # No prebuilt Intel macOS binary — fall back to a source build.
      url "https://github.com/randomparity/rusty-imap-mcp/archive/refs/tags/v0.1.0.tar.gz"
      sha256 "c633afda84ee0b3bb35259b8d0dd046f3212c300f765bafb95e26f7bed612dd1"
      depends_on "rust" => :build
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/randomparity/rusty-imap-mcp/releases/download/v0.1.0/rusty-imap-mcp-v0.1.0-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "efc9a2ff36b1665c9dcb1796c7eeae18477e0dff8170ebccc517ed30950964d7"
    end
    on_intel do
      url "https://github.com/randomparity/rusty-imap-mcp/releases/download/v0.1.0/rusty-imap-mcp-v0.1.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "784ab5b5295ff2412555c4a8a883e2f440c780dad588003162e7e311291c5c21"
    end
  end

  def install
    if OS.mac? && Hardware::CPU.intel?
      ENV["CARGO_TARGET_DIR"] = buildpath/"target"
      system "cargo", "install", "--locked", "--root", prefix, "--path", "crates/rimap-server"
    else
      bin.install "rusty-imap-mcp"
    end
  end

  test do
    assert_match "rusty-imap-mcp", shell_output("#{bin}/rusty-imap-mcp --version")
  end
end
