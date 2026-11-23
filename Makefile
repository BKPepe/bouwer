PHONY: debug
debug:
	cargo build

PHONY: release
release:
	cargo build --release

PHONY: cross-install
cross-install:
	cargo install cross --git https://github.com/cross-rs/cross

PHONY: cross-windows-debug
cross-windows-debug:
	RUSTFLAGS='-C link-args=-static' \
	cross build \
		--locked \
		--target x86_64-pc-windows-gnu

PHONY: cross-windows-release
cross-windows-release:
	RUSTFLAGS='-C link-args=-static' \
	cross build \
		--locked \
		--target x86_64-pc-windows-gnu \
		--release

PHONY: cross-windows-update
cross-windows-update:
	podman pull ghcr.io/cross-rs/x86_64-pc-windows-gnu:main

PHONY: cargo-update-any
cargo-update-any:
	CARGO_RESOLVER_INCOMPATIBLE_PUBLISH_AGE=allow \
	cargo update

assets/src/logo_%.png: assets/logo_no_shadow.svg
	@mkdir -p $(@D)
	rsvg-convert $< --width $* --height $* --output $@

# Sizes based on:
# https://learn.microsoft.com/en-us/windows/apps/design/iconography/app-icon-construction
assets/logo.ico: assets/src/logo_256.png
	magick $< -define icon:auto-resize=16,24,32,48,256 $@

PHONY: icons
icons: assets/logo.ico
