extends Node

# NOTE: The `FLATPAK_ID` is set slightly out of sync with most env vars. Getting it once the App has
# gone through most of it's initialization seems to work so far.
func get_flatpak_id() -> String:
  return OS.get_environment("FLATPAK_ID")
