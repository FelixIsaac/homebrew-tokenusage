class Tokenusage < Formula
  desc "Fast Rust CLI/TUI/GUI token usage tracker for Codex, Claude Code, Gemini CLI, OpenCode, and Antigravity usage."
  homepage "https://tokenusage.org"
  version "1.11.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/hanbu97/tokenusage/releases/download/v1.11.0/tokenusage-aarch64-apple-darwin.tar.xz"
      sha256 "e767f873a5fb8c69d3d956955c2c08fb8558a4c921f37a0a9ab11b39f5ff55b9"
    end
    if Hardware::CPU.intel?
      url "https://github.com/hanbu97/tokenusage/releases/download/v1.11.0/tokenusage-x86_64-apple-darwin.tar.xz"
      sha256 "a7e370330cdbad69010473c36edb0b303f05c4021e295bb76e1616edb57bbd21"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/hanbu97/tokenusage/releases/download/v1.11.0/tokenusage-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "a3dd4a4ce7e29abb8d8536c49c08cbb77d6d60719ed891b0214d2f43460d554b"
    end
    if Hardware::CPU.intel?
      url "https://github.com/hanbu97/tokenusage/releases/download/v1.11.0/tokenusage-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "965ea484b522edb2d42071f351dfa77ab566eaa11fc1a251f60961d0b7310cd4"
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
