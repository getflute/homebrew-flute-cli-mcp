class FluteCliMcp < Formula
  desc "MCP server that drives the flute payments CLI"
  homepage "https://github.com/getflute/flute-cli-mcp"
  version "1.0.0"
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/getflute/flute-cli-mcp/releases/download/v1.0.0/flute-cli-mcp-aarch64-apple-darwin.tar.xz"
    sha256 "21f5f8a1b89d8fe0a2dfd2dc85d1a7094f0c4b2ce3ba6540f598d96d967626f6"
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/getflute/flute-cli-mcp/releases/download/v1.0.0/flute-cli-mcp-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "448773114a67b556143bfcbffa052d78d84db1006cca90c323899750be052ed1"
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
