# frozen_string_literal: true

class JanetOpencode < Formula
  desc "Janet fork of OpenCode - AI coding agent for the terminal"
  homepage "https://github.com/MzxzD/Janet-OpenCode"
  license "MIT"

  head "https://github.com/MzxzD/Janet-OpenCode.git", branch: "dev"

  depends_on "oven-sh/bun/bun"
  depends_on "node"
  depends_on "ripgrep"

  def install
    # Install workspace deps from repo root
    system "bun", "install"

    # Build only for current platform (--single)
    opencode_dir = buildpath/"packages/opencode"
    cd opencode_dir do
      system "bun", "run", "build", "--", "--single"
    end

    # Find the built binary for this platform
    arch = Hardware::CPU.arm? ? "arm64" : "x64"
    os = OS.mac? ? "darwin" : "linux"
    binary_name = "opencode-#{os}-#{arch}"
    binary = opencode_dir/"dist/#{binary_name}/bin/opencode"

    raise "Build failed: #{binary} not found" unless binary.exist?

    bin.install binary => "janet-opencode"
  end

  test do
    assert_match "opencode", shell_output("#{bin}/janet-opencode --version")
  end
end
