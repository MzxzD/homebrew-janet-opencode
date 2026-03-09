# frozen_string_literal: true

class JanetOpencodeBundle < Formula
  desc "Janet OpenCode full bundle: OpenCode + janet-seed + preset + launcher"
  homepage "https://github.com/MzxzD/Janet-OpenCode"
  license "MIT"

  head "https://github.com/MzxzD/Janet-OpenCode.git", branch: "dev"

  depends_on "janet-opencode"
  depends_on "ollama"
  depends_on "python@3.12"

  resource "janetos" do
    url "https://codeload.github.com/MzxzD/JanetOS/zip/main"
    # sha256: update when JanetOS changes (brew fetch MzxzD/janet-opencode/janet-opencode-bundle 2>&1 | grep sha256)
    sha256 "0019dfc4b32d63c1392aa264aed2253c1e0c2fb09216f8e2cc269bbfb8bb49b5"
  end

  def install
    python = Formula["python@3.12"].opt_bin/"python3.12"

    # Install full JanetOS (needed for core/ privilege_guard, cloud_permission_guard)
    resource("janetos").stage do
      (pkgshare/"JanetOS").mkpath
      system "cp", "-R", "JanetOS-main/.", (pkgshare/"JanetOS").to_s
    end

    janetos_root = pkgshare/"JanetOS"

    # Requirements for janet_api_server: core + API + memory (chromadb)
    requirements = janetos_root/"janet-seed/requirements-bundle.txt"
    requirements.write <<~EOS
      psutil>=5.9.0
      pyyaml>=6.0
      cryptography>=41.0.0
      numpy>=1.24.0
      fastapi>=0.104.0
      uvicorn>=0.24.0
      litellm>=1.0.0
      requests>=2.31.0
      flask>=3.0.0
      flask-cors>=4.0.0
      websockets>=11.0.0
      chromadb>=0.4.0
    EOS

    venv = libexec/"venv"
    system python, "-m", "venv", venv
    system venv/"bin/pip", "install", "-r", requirements

    # Fetch and install Janet preset
    preset_dir = etc/"janet-opencode-bundle"
    preset_dir.mkpath
    system "curl", "-sSL", "-o", preset_dir/"opencode.json",
      "https://raw.githubusercontent.com/MzxzD/Janet-OpenCode/dev/config/janet-preset.json"

    # Launcher: starts server in background, runs janet-opencode
    (bin/"janet-opencode-start").write <<~EOS
      #!/bin/bash
      set -e
      JANETOS="#{janetos_root}"
      PRESET="#{etc}/janet-opencode-bundle/opencode.json"
      VENV="#{libexec}/venv"

      # Start janet_api_server in background if not already running
      if ! curl -s http://localhost:8080/health >/dev/null 2>&1; then
        echo "Starting janet_api_server..."
        cd "$JANETOS" && "$VENV/bin/python3" janet-seed/janet_api_server.py &
        sleep 3
      fi

      export OPENCODE_CONFIG="$PRESET"
      exec janet-opencode "$@"
    EOS

    # Server-only command (for running in separate terminal)
    (bin/"janet-opencode-server").write <<~EOS
      #!/bin/bash
      JANETOS="#{janetos_root}"
      VENV="#{libexec}/venv"
      cd "$JANETOS" && exec "$VENV/bin/python3" janet-seed/janet_api_server.py "$@"
    EOS

    chmod 0755, bin/"janet-opencode-start", bin/"janet-opencode-server"
  end

  def caveats
    <<~EOS
      Janet OpenCode Bundle installs:
        - janet-opencode-start (starts server + OpenCode)
        - janet-opencode-server (server only, for separate terminal)
        - JanetOS + janet-seed at #{pkgshare}/JanetOS
        - Janet preset at #{etc}/janet-opencode-bundle/opencode.json

      First run: ollama pull qwen2.5-coder:7b

      Then: janet-opencode-start
    EOS
  end

  test do
    assert_match "opencode", shell_output("janet-opencode --version")
  end
end
