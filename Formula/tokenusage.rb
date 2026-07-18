class Tokenusage < Formula
  desc "Fast Rust CLI/TUI/GUI token usage tracker for Codex, Claude Code, Gemini CLI, OpenCode, and Antigravity usage."
  homepage "https://tokenusage.org"
  version "1.11.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/hanbu97/tokenusage/releases/download/v1.11.0/tokenusage-aarch64-apple-darwin.tar.xz"
      sha256 "e79880fa59b375f7da1277bee4ef73f9407ad6eeb1f6e165591065ed90dbca12"
    end
    if Hardware::CPU.intel?
      url "https://github.com/hanbu97/tokenusage/releases/download/v1.11.0/tokenusage-x86_64-apple-darwin.tar.xz"
      sha256 "0c29e77238562fa0cd065f6bcf2e4b6ab034845f41afb5f36a87508f4ddbff2b"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/hanbu97/tokenusage/releases/download/v1.11.0/tokenusage-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "9c7d37aba594d3694ab9c1d6c51261eec0514e44e90a0e85efb0bf094f516555"
    end
    if Hardware::CPU.intel?
      url "https://github.com/hanbu97/tokenusage/releases/download/v1.11.0/tokenusage-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "d1fd9b98b29326e0e5ae889b3f0db9f9f9a0e633fc276032bcb146d285c7bda8"
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
