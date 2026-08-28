class FluteCliMcp < Formula
  desc "MCP server that drives the flute payments CLI"
  homepage "https://github.com/getflute/flute-cli-mcp"
  version "0.2.2"
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/getflute/flute-cli-mcp/releases/download/v0.2.2/flute-cli-mcp-aarch64-apple-darwin.tar.xz"
    sha256 "b9977962b4eb071bab3b5e4e2bc092b047ed4611ffb77d7b8981baee15339a9b"
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/getflute/flute-cli-mcp/releases/download/v0.2.2/flute-cli-mcp-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "08bf574d7f2ded38e93bc79569fa63b0f012cca321fec360adaa552fe041d881"
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":     {},
    "x86_64-pc-windows-gnu":    {},
    "x86_64-unknown-linux-gnu": {},
  }.freeze

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
