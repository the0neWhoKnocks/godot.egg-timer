class_name Utils extends Node

# ------------------------------------------------------------------------------

static func add_btn_style_override(node: Node, btn_color: String) -> void:
  var style1 = node.get_theme_stylebox("normal").duplicate()
  var style2 = node.get_theme_stylebox("pressed").duplicate()
  style1.bg_color = Color(btn_color)
  style2.bg_color = Color(str(btn_color, "CC")) # add opacity
  node.add_theme_stylebox_override("normal", style1)
  node.add_theme_stylebox_override("focus", style2)
  node.add_theme_stylebox_override("hover", style2)
  node.add_theme_stylebox_override("pressed", style2)

static func remove_btn_style_override(node: Node) -> void:
  node.remove_theme_stylebox_override("normal")
  node.remove_theme_stylebox_override("focus")
  node.remove_theme_stylebox_override("hover")
  node.remove_theme_stylebox_override("pressed")

static func dupe_stylebox(node: Node, state: String, states: Array[String]) -> void:
  var sb: StyleBoxFlat = node.get_theme_stylebox(state).duplicate()
  for st in states:
    node.add_theme_stylebox_override(st, sb)

enum StyleBoxState {
  DISABLED,
  FOCUS,
  HOVER,
  NORMAL,
  PANEL,
  PRESSED,
}
const STYLEBOX_STATES = {
  StyleBoxState.DISABLED: &"disabled",
  StyleBoxState.FOCUS: &"focus",
  StyleBoxState.HOVER: &"hover",
  StyleBoxState.NORMAL: &"normal",
  StyleBoxState.PANEL: &"panel",
  StyleBoxState.PRESSED: &"pressed",
}
static func update_stylebox(
  states: Array[StyleBoxState],
  nodes_n_props: Array,
  val,
):
  var sb: StyleBoxFlat
  for arr in nodes_n_props:
    var node: Node = arr[0]
    var props: Array = arr[1]
    for state in states:
      if node && node.has_theme_stylebox_override(STYLEBOX_STATES[state]):
        sb = node.get_theme_stylebox(STYLEBOX_STATES[state])
        for prop in props:
          sb[prop] = val

# ------------------------------------------------------------------------------

static func gen_uuid4() -> String:
  const UUID_CHARS = "0123456789abcdef"
  var result: String = ""
  
  for i in range(32):
    if i in [8, 12, 16, 20]:
      result += "-"
    
    if i == 12:
      result += "4" # Version 4
    elif i == 16:
      # Variant bits logic
      var r := randi() % 16
      r = (r & 0x3) | 0x8 
      result += UUID_CHARS[r]
    else:
      var r := randi() % 16
      result += UUID_CHARS[r]
            
  return result

# ------------------------------------------------------------------------------

static func get_user_app_data_path() -> String:
  var HOME: String = get_user_home_path()
  var data_path: String
  
  # Inside a FP Sandbox
  if Env.get_flatpak_id(): return "/var/config"
  
  match OS.get_name():
    "Linux", "X11": # "X11" is commonly returned in older Godot versions or specific configurations
      data_path = HOME + "/.config"
    "macOS":
      data_path = HOME + "/Library/Application Support"
    "Windows":
      data_path = OS.get_environment("APPDATA") # `Roaming` folder so settings can sync
    _: # unknown system
      data_path = OS.get_user_data_dir()
  
  return data_path
  

static func get_user_home_path() -> String:
  if OS.has_environment("HOME"):
    return OS.get_environment("HOME") # Linux, macOS
  elif OS.has_environment("USERPROFILE"):
    return OS.get_environment("USERPROFILE") # Windows
  return ""

# ------------------------------------------------------------------------------
