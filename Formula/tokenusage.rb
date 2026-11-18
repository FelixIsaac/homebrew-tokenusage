class Tokenusage < Formula
  desc "Fast Rust CLI/TUI/GUI token usage tracker for Codex, Claude Code, Gemini CLI, OpenCode, and Antigravity usage."
  homepage "https://tokenusage.org"
  version "1.12.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/FelixIsaac/tokenusage/releases/download/v1.12.1/tokenusage-aarch64-apple-darwin.tar.xz"
      sha256 "85f0924c30e80792f297e3b4505f9e54b0118b212336084e46a215944704c486"
    end
    if Hardware::CPU.intel?
      url "https://github.com/FelixIsaac/tokenusage/releases/download/v1.12.1/tokenusage-x86_64-apple-darwin.tar.xz"
      sha256 "75aaf0dca00eb6fc9d8c81b641cdfb6a03f08348ab7f117938dd52c14e7b83fe"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/FelixIsaac/tokenusage/releases/download/v1.12.1/tokenusage-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "8ce4ff5db861d600d076e0db7ae5d0a7d180a376f9f5eb0513aca3be4e17d76a"
    end
    if Hardware::CPU.intel?
      url "https://github.com/FelixIsaac/tokenusage/releases/download/v1.12.1/tokenusage-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "b46f3ce3b05fa76525158069a9c84f1603a2f75e41a7ddb97566254baa3906b1"
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
