# homebrew-brew

Homebrew formulae for my own tools:

- [dathan](https://github.com/waddie/dathan): highlight source code to HTML,
  Hiccup or ANSI, using Helix’s tree-sitter grammars.
- [quipu](https://github.com/waddie/quipu): script keyboard entry in the
  terminal, for recording demos.

## Install

```sh
brew install waddie/brew/dathan
brew install waddie/brew/quipu
```

Or `brew tap waddie/brew` first, then install by name.

dathan pulls in Homebrew’s `helix` for its runtime and wraps the binary to use
it when `HELIX_RUNTIME` is unset. `~/.config/helix/runtime` still takes
priority. If you already have a Helix runtime, `--without-helix` skips the
dependency and builds from source.

## Maintenance

- `brew bump` runs daily via `autobump.yml` and opens a PR for any new release.
  It needs a `HOMEBREW_BUMP_TOKEN` secret: a fine-grained PAT on this repo with
  read/write Contents and Pull requests. `GITHUB_TOKEN` won’t do, as PRs it
  opens don’t trigger test-bot.
- When test-bot is green on a PR, run the “brew pr-pull” workflow with the PR
  number. It uploads the bottles and pushes to `main`.
- dathan vendors helix’s `languages.toml`, pinned to the helix version in
  homebrew-core. Autobump won’t touch it, so bump the `helix-languages`
  resource by hand when helix releases.
