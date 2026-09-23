#!/usr/bin/env bash

# Godot ------------------------------------------------------------------------

# Export Production build:
godot --headless --export-release "Linux"
# Export Debug build:
# godot --headless --export-debug

# Installer --------------------------------------------------------------------

export FP__APP_ID="org.lemlab.EggTimer"
export FP__COMMAND="eggtimer"
export PATH__ASSETS_DIR="$PWD/assets"
export PATH__BIN_ASSETS_DIR="$PWD/bin/assets"
export PATH__BUILD_DIR="$PWD/.build"
export PATH__DIST_DIR="$PWD/dist"

# The desktop file and the icon file name must match the `app-id` (e.g., 
# `org.example.MyBinaryApp.desktop` and `org.example.MyBinaryApp.png`). If they
# do not match, the desktop environment will fail to map the icon to your
# running window.
mkdir -p "$PATH__BUILD_DIR"
cp "$PATH__BIN_ASSETS_DIR/launcher.desktop" "$PATH__BUILD_DIR/$FP__APP_ID.desktop"
  sed -i "s/{FP__COMMAND}/$FP__COMMAND/g" "$PATH__BUILD_DIR/$FP__APP_ID.desktop"
  sed -i "s/{FP__ICON}/$FP__APP_ID/g" "$PATH__BUILD_DIR/$FP__APP_ID.desktop"
cp "$PATH__ASSETS_DIR/icons/app.svg" "$PATH__BUILD_DIR/$FP__APP_ID.svg"
cp "$PATH__ASSETS_DIR/icons/app-symbolic.svg" "$PATH__BUILD_DIR/$FP__APP_ID-symbolic.svg"

# `flatpack-builder` doesn't parse Host env variables in the manifest, so use
# `envsubst` to swap variable references with their values. Unfortunately there
# is no "exclude these vars" option, instead you have to specify every variable
# you want to replace in order to ensure vars like `FLATPAK_DEST` don't get
# stripped out when an env var is not found.
envsubst '$FP__APP_ID $FP__COMMAND $PATH__BUILD_DIR $PATH__DIST_DIR' < ./bin/flatpak.yaml > "$PATH__BUILD_DIR/build.yaml"
# Create the local flatpak repo with your App.
#  - CAUTION: `--force-clean` will wipe everything in the specified folder.
flatpak-builder --repo="$PATH__BUILD_DIR/fp/repo" --install-deps-from=flathub --force-clean "$PATH__BUILD_DIR/fp" "$PATH__BUILD_DIR/build.yaml"
# Create the `.flatpak` installer from the repo.
flatpak build-bundle "$PATH__BUILD_DIR/fp/repo" "$PATH__DIST_DIR/eggtimer.flatpak" org.lemlab.EggTimer

# Clean-up ---------------------------------------------------------------------

# Remove build files.
rm -rf "$PATH__BUILD_DIR"
