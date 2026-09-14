class_name AppConfig extends BaseConfig

var timers: Dictionary = {}

func _init() -> void:
  super("eggtimer")
  
  if !data["timers"]: data["timers"] = timers
  else: timers = data["timers"]


func set_timer(uid: String, timer_data: Dictionary) -> void:
  timers[uid] = timer_data
  save_file()
