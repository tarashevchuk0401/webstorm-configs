#!/usr/bin/env bash
#
# Sync curated WebStorm settings between this repo and the local JetBrains config dir.
#
#   ./sync.sh export   # local settings  -> repo  (copy your current IDE prefs in)
#   ./sync.sh import   # repo            -> local (apply repo prefs to your IDE)
#
# Only the allowlisted, portable files below are touched. Licenses, tokens,
# database credentials and window/runtime state are never synced.
#
# Quit WebStorm before running `import` so it doesn't overwrite on exit.

set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/webstorm"

# Pick the newest WebStorm* config dir unless WEBSTORM_CONFIG_DIR is set.
if [[ -n "${WEBSTORM_CONFIG_DIR:-}" ]]; then
  LOCAL_DIR="$WEBSTORM_CONFIG_DIR"
else
  case "$(uname -s)" in
    Darwin) base="$HOME/Library/Application Support/JetBrains" ;;
    Linux)  base="$HOME/.config/JetBrains" ;;
    *)      echo "Unsupported OS; set WEBSTORM_CONFIG_DIR" >&2; exit 1 ;;
  esac
  LOCAL_DIR="$(find "$base" -maxdepth 1 -type d -name 'WebStorm*' | sort | tail -n1)"
fi

[[ -d "$LOCAL_DIR" ]] || { echo "WebStorm config dir not found: $LOCAL_DIR" >&2; exit 1; }

# Relative paths (under both REPO_DIR and LOCAL_DIR) that get synced.
FILES=(
  codestyles/Default.xml
  "keymaps/macOS copy.xml"
  "keymaps/Windows copy.xml"
  options/editor.xml
  options/editor-font.xml
  options/console-font.xml
  options/terminal-font.xml
  options/colors.scheme.xml
  options/laf.xml
  options/filetypes.xml
  options/advancedSettings.xml
  options/ide.general.xml
  options/intentionSettings.xml
  options/baseRefactoring.xml
  options/diff.xml
  options/debugger.xml
  options/terminal.xml
  options/textmate.xml
  options/projectView.xml
  options/find.xml
  options/spellchecker-dictionary.xml
)

mode="${1:-}"
case "$mode" in
  export) src="$LOCAL_DIR"; dst="$REPO_DIR" ;;
  import) src="$REPO_DIR"; dst="$LOCAL_DIR" ;;
  *) echo "usage: $0 {export|import}" >&2; exit 1 ;;
esac

echo "$mode: $src  ->  $dst"
for rel in "${FILES[@]}"; do
  if [[ -f "$src/$rel" ]]; then
    mkdir -p "$dst/$(dirname "$rel")"
    cp "$src/$rel" "$dst/$rel"
    echo "  $rel"
  else
    echo "  skip (absent): $rel"
  fi
done
echo "done"
