class Tokenusage < Formula
  desc "Fast Rust CLI/TUI/GUI token usage tracker for Codex, Claude Code, Gemini CLI, OpenCode, and Antigravity usage."
  homepage "https://tokenusage.org"
  version "1.11.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/FelixIsaac/tokenusage/releases/download/v1.11.1/tokenusage-aarch64-apple-darwin.tar.xz"
      sha256 "6f26e29dbc4181d4b33c7dfcca1380df3e039633f7347353dcbc23f06826d3c7"
    end
    if Hardware::CPU.intel?
      url "https://github.com/FelixIsaac/tokenusage/releases/download/v1.11.1/tokenusage-x86_64-apple-darwin.tar.xz"
      sha256 "f0f6988e88cba5b9f4f10b8b58c375ebe7a9ab54c27462bee633993578ea0bc0"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/FelixIsaac/tokenusage/releases/download/v1.11.1/tokenusage-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "1c00d8c2cbd0a743a2c028dda7ed65530f2478479b04e0b9cb450b8dc4ff1697"
    end
    if Hardware::CPU.intel?
      url "https://github.com/FelixIsaac/tokenusage/releases/download/v1.11.1/tokenusage-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "0f6f68306ef31c19983cbcb207bb216ee8d536c1ad8502b75aaed39056557751"
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
    bin.install "tu" if OS.mac? && Hardware::CPU.arm?
    bin.install "tu" if OS.mac? && Hardware::CPU.intel?
    bin.install "tu" if OS.linux? && Hardware::CPU.arm?
    bin.install "tu" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
