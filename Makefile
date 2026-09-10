# One-line commands. Run `make` on its own to see them.
APP_ID  := io.github.sudo_bluuuk.HebrewBear
RUNTIME := 49
BUNDLE  := hebrewbear.flatpak

.DEFAULT_GOAL := help
.PHONY: help dev run test flatpak flatpak-deps install-local clean

help:  ## Show this list
	@grep -hE '^[a-z-]+:.*?## ' $(MAKEFILE_LIST) \
		| awk -F':.*?## ' '{printf "  make %-14s %s\n", $$1, $$2}'

# Codegen is part of the build, not a separate thing to remember: drift writes
# dbmanager.g.dart and nothing compiles without it on a fresh checkout.
generated: pubspec.yaml lib/data/dbmanager.dart
	flutter pub get
	dart run build_runner build
	@touch generated

dev: generated  ## Run the app with hot reload
	flutter run -d linux

test: generated  ## Analyse and run the test suite
	flutter analyze
	flutter test

flatpak: generated  ## Build a single .flatpak file to send to someone
	flutter build linux --release
	flatpak-builder --user --force-clean --install-deps-from=flathub \
		--repo=build/flatpak-repo build/flatpak-build \
		flatpak/$(APP_ID).yml
	flatpak build-bundle build/flatpak-repo $(BUNDLE) $(APP_ID)
	@echo
	@echo "Built $(BUNDLE) ($$(du -h $(BUNDLE) | cut -f1)). Send it over; they install with:"
	@echo "  flatpak install --user ./$(BUNDLE)"

flatpak-deps:  ## Install what the flatpak build needs (one time)
	sudo pacman -S --needed flatpak-builder
	flatpak install --user -y flathub org.gnome.Platform//$(RUNTIME) org.gnome.Sdk//$(RUNTIME)

install-local: flatpak  ## Build and install it here, to check what Dudu will get
	flatpak install --user -y --reinstall ./$(BUNDLE)
	@echo "Installed. Run with: flatpak run $(APP_ID)"

clean:  ## Remove build output
	flutter clean
	rm -rf build/flatpak-repo build/flatpak-build $(BUNDLE) generated
