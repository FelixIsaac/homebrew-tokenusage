class Tokenusage < Formula
  desc "Fast Rust CLI/TUI/GUI token usage tracker for Codex, Claude Code, Gemini CLI, OpenCode, and Antigravity usage."
  homepage "https://tokenusage.org"
  version "1.11.2"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/FelixIsaac/tokenusage/releases/download/v1.11.2/tokenusage-aarch64-apple-darwin.tar.xz"
      sha256 "f20372a4a843fe41cade28fc7e981f1ec07d96b26b989311b42f9a9b6a5b0d9b"
    end
    if Hardware::CPU.intel?
      url "https://github.com/FelixIsaac/tokenusage/releases/download/v1.11.2/tokenusage-x86_64-apple-darwin.tar.xz"
      sha256 "356629b36ac0a705d86cd90fe4757def353f679e9cea63bc11d9b955fd6ed73f"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/FelixIsaac/tokenusage/releases/download/v1.11.2/tokenusage-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "4168cc0b0582dee5e1df2ad5b7a7d76fe65dc0a7f0eb252e29deea12e95d3046"
    end
    if Hardware::CPU.intel?
      url "https://github.com/FelixIsaac/tokenusage/releases/download/v1.11.2/tokenusage-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "a7af1ffaa6aadae06fb766164be67083fe5bcaa55acca4c79cbcb57492363df5"
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
