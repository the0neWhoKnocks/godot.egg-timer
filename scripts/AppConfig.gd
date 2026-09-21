class_name AppConfig extends BaseConfig

var timers: Dictionary = {}

func _init() -> void:
  super("eggtimer")
  
  if !data["timers"]: data["timers"] = timers
  else: timers = data["timers"]


func delete_timer(uid: String) -> void:
  if timers.erase(uid): save_file()


func get_timer(uid: String) -> Dictionary:
  return timers[uid]


func load_file() -> void:
  super()
  # Ensure timer data matches what is expected
  for uid in data["timers"]:
    var timer: Dictionary = data["timers"][uid]
    timer["color"] = str(timer["color"])
    timer["hours"] = int(timer["hours"])
    timer["mins"] = int(timer["mins"])
    timer["name"] = str(timer["name"])
    timer["secs"] = int(timer["secs"])
  

func set_timer(uid: String, timer_data: Dictionary) -> void:
  timers[uid] = timer_data
  save_file()
