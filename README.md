# Godot EggTimer

Timer App built with Godot

- [Build a Flatpak Installer](#build-a-flatpak-installer)
- [Install](#install)
  - [Run Installed](#run-installed)
- [Uninstall](#uninstall)
- [Known Issues](#known-issues)

---

## Build a Flatpak Installer

Build the binary and flatpak (Linux):
```sh
./bin/build.sh
```

---

## Install

```sh
flatpak install --user ./dist/eggtimer.flatpak
```

### Run Installed

You should be able to run it like any other Flatpak app. If it doesn't start for some reason, you can run this to debug.
```sh
flatpak run -vv org.lemlab.EggTimer
```

---

## Uninstall

```sh
flatpak uninstall org.lemlab.EggTimer
```

---

## Known Issues

- When clicking outside of an open ColorPicker there are errors regarding `focus_entered` and `tree_exited`. This only happens in an exported build and seems to be [related to 95512](https://github.com/godotengine/godot/issues/95512).
