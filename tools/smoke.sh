#!/bin/sh
# Launches the installed flatpak and checks it actually opened the database.
#
# "It started and printed nothing to stderr" is not a working app: a failure to
# load libsqlite3 is drawn inside the Flutter UI, where watching stderr will
# never see it. Having the database file open is proof sqlite loaded.
set -eu
app=${1:-io.github.sudo_bluuuk.HebrewBear}
db=${2:-$HOME/Documents/words.sqlite3}

app_pid() {
  for p in $(ls /proc | grep -E '^[0-9]+$'); do
    case "$(readlink /proc/"$p"/exe 2>/dev/null)" in
      /app/share/*) echo "$p"; return ;;
    esac
  done
}

flatpak run "$app" >/dev/null 2>&1 &
sleep 8

pid=$(app_pid || true)
[ -n "${pid:-}" ] || { echo "  SMOKE FAIL: the app is not running"; exit 1; }

if lsof -p "$pid" 2>/dev/null | grep -q "$(basename "$db")"; then
  echo "  smoke: app has $(basename "$db") open — sqlite loaded"
  status=0
else
  echo "  SMOKE FAIL: $(basename "$db") is not open — sqlite almost certainly failed to load"
  status=1
fi

kill "$pid" 2>/dev/null || true
exit "$status"
