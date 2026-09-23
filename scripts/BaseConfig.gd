class_name BaseConfig extends RefCounted

var PATH__USER_DATA: String = Utils.get_user_app_data_path()
var data: Dictionary
var dir: String
var file: String


func _init(app_name: String, config_name: String = "config") -> void:
  dir = PATH__USER_DATA if Env.get_flatpak_id() else PATH__USER_DATA + "/" + app_name
  file = dir + "/" + config_name + ".json"
  data = {}
  load_file()


func load_file() -> void:
  if FileAccess.file_exists(file):
    var raw_data = FileAccess.get_file_as_string(file)
    var json_data = JSON.parse_string(raw_data)
    data = json_data if json_data != null else {}
  else:
    save_file()


func save_file() -> void:
  if not DirAccess.dir_exists_absolute(dir):
    DirAccess.make_dir_recursive_absolute(dir)
  
  var json = JSON.stringify(data, "  ", true)
  var fo = FileAccess.open(file, FileAccess.WRITE)
  
  if fo == null:
    print("Failed to open file: ", FileAccess.get_open_error())
    return
  
  fo.store_string(json)
  fo.close()
