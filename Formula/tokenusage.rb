class Tokenusage < Formula
  desc "Fast Rust CLI/TUI/GUI token usage tracker for Codex, Claude Code, Gemini CLI, OpenCode, and Antigravity usage."
  homepage "https://tokenusage.org"
  version "1.11.6"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/FelixIsaac/tokenusage/releases/download/v1.11.6/tokenusage-aarch64-apple-darwin.tar.xz"
      sha256 "8bfac7effb5b7452ddddd562632cb9177bd1f1f409cbcddfcceb8ef68eae5f70"
    end
    if Hardware::CPU.intel?
      url "https://github.com/FelixIsaac/tokenusage/releases/download/v1.11.6/tokenusage-x86_64-apple-darwin.tar.xz"
      sha256 "fd71f072dc44f211bd245f39f9654dd6b0ebfc2cf899d4eadcdfd09ea669ee4a"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/FelixIsaac/tokenusage/releases/download/v1.11.6/tokenusage-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "b20cfd1902b2787b5dee2afd228f4147d762a5f94e4b003fb7f83730715fc00e"
    end
    if Hardware::CPU.intel?
      url "https://github.com/FelixIsaac/tokenusage/releases/download/v1.11.6/tokenusage-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "c483a50e50689cede9be13c64f9fa7fce7186a1e1d0510fc4e41a5ca6d67a829"
    end
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":      {},
    "aarch64-unknown-linux-gnu": {},
    "x86_64-apple-darwin":       {},
    "x86_64-pc-windows-gnu":     {},
    "x86_64-unknown-linux-gnu":  {},
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
      bin.install "tu"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "tu"
    end
    if OS.linux? && Hardware::CPU.arm?
      bin.install "tu"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "tu"
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
