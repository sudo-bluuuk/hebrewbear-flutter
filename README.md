# Hebrew Bear

A personal Hebrew vocabulary book. Verbs are stored as a root plus a binyan and
their forms are generated on demand; nouns and adjectives are stored as written.

## Commands

    make dev       run the app with hot reload
    make test      analyse and run the test suite
    make share     show what has been built and how to install each

`make` on its own lists them all. Codegen (drift) is part of every target, so a
fresh checkout needs nothing else.

## Sending it to someone

Everything lands in `dist/`, and each build prints the file to send along with
the command the recipient runs.

| Build | They get | Works on |
| --- | --- | --- |
| `make arch` | 11 MB package, `gtk3` its only dependency | Arch only |
| `make flatpak` | 8.5 MB bundle, plus the GNOME runtime if they lack it | any distro |
| `make flatpak-kde` | same, against the KDE runtime instead | any distro |

Prefer `make arch` if they run Arch — a tenth of the download and no runtime.
Otherwise pick the flatpak whose runtime they already have; ask them to run
`flatpak list --runtime | grep -E 'gnome|kde'`.

The flatpak build needs `make flatpak-deps` once. `make install-local` builds
and installs it here so you can see what they will get before sending.

## Conjugation

Rules cover the regular patterns, several weak root classes, four-letter roots
and the Hitpael metathesis. Accuracy is measured rather than assumed:
`test/fixtures/verbs.dart` holds known-correct forms and `test/accuracy_test.dart`
fails if any of them changes in either direction.

Where a verb is genuinely irregular, any single form can be corrected in the app
and the correction is kept. Built-in corrections live in `lib/data/irregulars.dart`.

## Storage

The word database is `~/Documents/words.sqlite3`. `seed/` holds a starter
vocabulary and the SQL to import it.
