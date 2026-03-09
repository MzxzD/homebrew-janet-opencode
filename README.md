# Homebrew Tap for Janet-OpenCode

[Janet-OpenCode](https://github.com/MzxzD/Janet-OpenCode) — Janet fork of [OpenCode](https://opencode.ai), the open source AI coding agent.

## Install

```bash
# Add the tap (repo must be: github.com/MzxzD/homebrew-janet-opencode)
brew tap MzxzD/janet-opencode

# Install from latest dev (builds from source)
brew install --HEAD janet-opencode
```

Then run:

```bash
janet-opencode
```

## Requirements

- **Homebrew**
- **Bun** (installed automatically as a dependency)
- **Node** (for some tooling)
- **ripgrep**

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
