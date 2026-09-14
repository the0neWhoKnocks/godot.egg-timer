class_name Utils extends Node

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


static func get_user_app_data_path() -> String:
  var HOME: String = get_user_home_path()
  var data_path: String
  
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
