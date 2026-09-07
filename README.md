# webstorm-configs

Version-controlled, portable WebStorm/JetBrains IDE settings.

## What's here

```
webstorm/
  codestyles/   code style scheme (Default.xml)
  keymaps/      custom keymaps (macOS, Windows)
  options/      editor, fonts, color scheme, LAF, file types, spellcheck dict, …
```

Only portable preference files are tracked. **Not** included, by design
(see `.gitignore`): license keys (`*.key`, `plugin_*.license`), auth tokens,
database credentials (`databaseSettings.xml`), VCS tokens (`github.xml`,
`gitlab.xml`), proxy settings, and window/runtime state.

Source config dir: `~/Library/Application Support/JetBrains/WebStorm<version>/`
(macOS) or `~/.config/JetBrains/WebStorm<version>/` (Linux).

## Usage

```sh
./sync.sh export   # copy current IDE settings into this repo, then commit
./sync.sh import   # apply repo settings to your IDE (quit WebStorm first)
```

`sync.sh` auto-detects the newest `WebStorm*` config dir. Override with
`WEBSTORM_CONFIG_DIR=/path/to/WebStorm2025.2 ./sync.sh import`.

The script only touches an explicit allowlist of files — the same set that's
tracked here.
