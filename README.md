# Homebrew Tap for Janet-OpenCode

[Janet-OpenCode](https://github.com/MzxzD/Janet-OpenCode) — Janet fork of [OpenCode](https://opencode.ai), the open source AI coding agent.

## Install

### Option A: OpenCode only (manual janet-seed setup)

```bash
brew tap MzxzD/janet-opencode
brew install --HEAD janet-opencode
```

Then run: `janet-opencode`

### Option B: Full bundle (recommended)

One command installs OpenCode + janet-seed API server + Janet preset + launcher scripts:

```bash
brew tap MzxzD/janet-opencode
brew install --HEAD MzxzD/janet-opencode/janet-opencode-bundle
```

First run: `ollama pull qwen2.5-coder:7b` (or your preferred model)

Then: `janet-opencode-start` — starts janet_api_server in background and launches OpenCode with the Janet preset.

## Bundle commands

| Command | Purpose |
|---------|---------|
| `janet-opencode-start` | Start janet_api_server + launch OpenCode with Janet preset |
| `janet-opencode-server` | Run janet_api_server only (e.g. in a separate terminal) |

## Requirements

- **Homebrew**
- **Bun** (installed automatically as a dependency)
- **Node** (for some tooling)
- **ripgrep**
- **Bundle only**: Ollama, Python 3.12 (installed automatically)

## Upgrade

```bash
brew upgrade --HEAD janet-opencode
```

## Uninstall

```bash
brew uninstall janet-opencode
brew untap MzxzD/janet-opencode
```

## Repo setup

1. Create a GitHub repo named `homebrew-janet-opencode` under your account.
2. Push this tap (Formula + README) to it.
3. Ensure [Janet-OpenCode](https://github.com/MzxzD/Janet-OpenCode) is public (or install will fail to clone).

## Adding stable releases (optional)

To support `brew install janet-opencode` without `--HEAD`:

1. Create a release (e.g. `v1.2.23`) in the Janet-OpenCode repo.
2. Add a `url` and `sha256` to the formula:
   ```ruby
   url "https://github.com/MzxzD/Janet-OpenCode/archive/refs/tags/v1.2.23.tar.gz"
   sha256 "..." # curl -sL <url> | shasum -a 256
   ```
