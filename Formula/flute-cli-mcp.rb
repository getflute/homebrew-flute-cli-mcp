class FluteCliMcp < Formula
  desc "MCP server that drives the flute payments CLI"
  homepage "https://github.com/getflute/flute-cli-mcp"
  version "0.2.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/getflute/flute-cli-mcp/releases/download/v0.2.0/flute-cli-mcp-aarch64-apple-darwin.tar.xz"
      sha256 "2ee92533117a164849c4d32e86ade7018fa15508eb61db9f59c397a7cb93d982"
    end
  end
  if OS.linux?
    if Hardware::CPU.intel?
      url "https://github.com/getflute/flute-cli-mcp/releases/download/v0.2.0/flute-cli-mcp-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "9c8d4068323c80a8ff6db35cf28210b30e4be54b4786a4a0db5cf8c05d10932d"
    end
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin": {},
    "x86_64-pc-windows-gnu": {},
    "x86_64-unknown-linux-gnu": {}
  }

  def target_triple
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    os = OS.mac? ? "apple-darwin" : "unknown-linux-gnu"

    "#{cpu}-#{os}"
  end

  def install_binary_aliases!
    BINARY_ALIASES[target_triple.to_sym].each do |source, dests|
      dests.each do |dest|
        bin.install_symlink bin/source.to_s => dest
      end
    end
  end

  def install
    if OS.mac? && Hardware::CPU.arm?
      bin.install "flute-cli-mcp"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "flute-cli-mcp"
    end

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
