#!/bin/sh
# Prints where a built artefact is and how the recipient installs it.
#
# Its own script rather than an echo in each target: the install command depends
# on the file type, and build tools print enough noise that this needs to stand
# out to be read at all.
set -eu

found=0
for file in "$@"; do
  [ -f "$file" ] || continue
  found=1
  name=$(basename "$file")
  case "$name" in
    *.flatpak)     install="flatpak install --user ./$name" ;;
    *.pkg.tar.zst) install="sudo pacman -U ./$name" ;;
    *.AppImage)    install="chmod +x $name && ./$name" ;;
    *)             install="(unrecognised file type)" ;;
  esac

  printf '\n'
  printf '  ──────────────────────────────────────────────────────────\n'
  printf '   send this:  %s\n' "$(realpath "$file")"
  printf '   size:       %s\n' "$(du -h "$file" | cut -f1)"
  printf '   they run:   %s\n' "$install"
  printf '  ──────────────────────────────────────────────────────────\n'
  printf '\n'
done

[ "$found" = 1 ] || printf '\n  Nothing built yet. Try: make flatpak, or make arch\n\n'
