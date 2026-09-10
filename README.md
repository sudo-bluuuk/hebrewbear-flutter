# Hebrew Bear

A personal Hebrew vocabulary book. Verbs are stored as a root plus a binyan and
their forms are generated on demand; nouns and adjectives are stored as written.

## Commands

    make dev       run the app with hot reload
    make test      analyse and run the test suite
    make flatpak   build hebrewbear.flatpak, a single file to send to someone

`make` on its own lists them. Codegen (drift) is part of every target, so a
fresh checkout needs nothing else.

### Building the flatpak

One time:

    make flatpak-deps

Then `make flatpak` produces `hebrewbear.flatpak`. Whoever you send it to
installs it with:

    flatpak install --user ./hebrewbear.flatpak
    flatpak run io.github.sudo_bluuuk.HebrewBear

`make install-local` builds and installs it here, to see what they will get.

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
