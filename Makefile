# One-line commands. Run `make` on its own to see them.
APP_ID := io.github.sudo_bluuuk.HebrewBear

# Which runtime the flatpak targets. Flutter's Linux embedder is GTK-based, so
# the runtime only has to provide GTK3 — GNOME and KDE both do.
RUNTIME_ID  ?= org.gnome.Platform
RUNTIME_VER ?= 49
SDK_ID      := $(subst Platform,Sdk,$(RUNTIME_ID))

# Everything meant for someone else lands here, so there is one place to look.
DIST     := dist
BUNDLE   ?= $(DIST)/hebrewbear.flatpak
MANIFEST := flatpak/.build.yml

BUNDLE_DIR := build/linux/x64/release/bundle
# The sqlite3 package builds this through a Dart build hook, but Flutter does
# not copy it into the app bundle. Without it the app falls back to dlopen'ing
# the system libsqlite3.so — which exists on a dev machine and does NOT exist
# inside a flatpak, where the runtime ships only the versioned soname.
NATIVE_SQLITE := build/native_assets/linux/libsqlite3.so

# `arch` and `dist` are also directory names; without this make sees the
# directory, decides the target is already satisfied and does nothing.
.PHONY: help dev test flatpak flatpak-kde arch share flatpak-deps install-local clean

help:  ## Show this list
	@grep -hE '^[a-z-]+:.*?## ' $(MAKEFILE_LIST) \
		| awk -F':.*?## ' '{printf "  make %-14s %s\n", $$1, $$2}'

# Codegen is part of the build, not a separate thing to remember: drift writes
# dbmanager.g.dart and nothing compiles without it on a fresh checkout.
generated: pubspec.yaml lib/data/dbmanager.dart
	flutter pub get
	dart run build_runner build
	@touch generated

release: generated
	flutter build linux --release
	@test -f $(NATIVE_SQLITE) || { \
		echo "ERROR: $(NATIVE_SQLITE) missing — the sqlite3 build hook did not run."; \
		echo "       Try: flutter clean && make release"; exit 1; }
	@# libflutter_linux_gtk.so has RUNPATH $$ORIGIN, so lib/ is where dlopen looks.
	install -m644 $(NATIVE_SQLITE) $(BUNDLE_DIR)/lib/
	@tools/check-bundle.sh $(BUNDLE_DIR)

dev: generated  ## Run the app with hot reload
	flutter run -d linux

test: generated  ## Analyse and run the test suite
	flutter analyze
	flutter test

# Written next to the real manifest so its relative source paths still resolve.
$(MANIFEST): flatpak/$(APP_ID).yml
	sed -e 's|^runtime: .*|runtime: $(RUNTIME_ID)|' \
	    -e "s|^runtime-version: .*|runtime-version: '$(RUNTIME_VER)'|" \
	    -e 's|^sdk: .*|sdk: $(SDK_ID)|' $< > $@

flatpak: release $(MANIFEST)  ## Build a .flatpak — works on any distro
	@mkdir -p $(DIST)
	flatpak-builder --user --force-clean --install-deps-from=flathub \
		--repo=build/flatpak-repo build/flatpak-build $(MANIFEST)
	flatpak build-bundle build/flatpak-repo $(BUNDLE) $(APP_ID)
	@tools/announce.sh $(BUNDLE)

flatpak-kde:  ## Same, against the KDE runtime instead of GNOME
	$(MAKE) flatpak RUNTIME_ID=org.kde.Platform RUNTIME_VER=6.10 \
		BUNDLE=$(DIST)/hebrewbear-kde.flatpak

arch: release  ## Build an Arch package — smallest, but Arch only
	@mkdir -p $(DIST)
	cd arch && PKGDEST=$(CURDIR)/$(DIST) makepkg --force --nodeps
	@tools/announce.sh $$(ls -1t $(DIST)/*.pkg.tar.zst | head -1)

share:  ## Show everything built so far and how to install each
	@tools/announce.sh $(DIST)/*

flatpak-deps:  ## Install what the flatpak build needs (one time)
	sudo pacman -S --needed flatpak-builder
	flatpak install --user -y flathub \
		$(RUNTIME_ID)//$(RUNTIME_VER) $(SDK_ID)//$(RUNTIME_VER)

install-local: flatpak  ## Build, install here and smoke-test what they will get
	flatpak install --user -y --reinstall ./$(BUNDLE)
	@tools/smoke.sh $(APP_ID)
	@echo "Installed. Run with: flatpak run $(APP_ID)"

clean:  ## Remove build output
	flutter clean
	rm -rf build/flatpak-repo build/flatpak-build $(MANIFEST) $(DIST) generated
	rm -rf arch/pkg arch/src
