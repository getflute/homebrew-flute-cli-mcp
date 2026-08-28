class FluteCliMcp < Formula
  desc "MCP server that drives the flute payments CLI"
  homepage "https://github.com/getflute/flute-cli-mcp"
  version "0.2.3"
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/getflute/flute-cli-mcp/releases/download/v0.2.3/flute-cli-mcp-aarch64-apple-darwin.tar.xz"
    sha256 "c7c457849c6b47887706383669336fd559019bf035f389cb46cad83a983d6311"
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/getflute/flute-cli-mcp/releases/download/v0.2.3/flute-cli-mcp-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "6bfafd495dde0d6610ee91a105085aea3d916234e3625e30aa320f7edd130cf9"
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
