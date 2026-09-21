class_name App extends Node

var completed_timers: Array = []
var config: AppConfig = AppConfig.new()
var timers_completed: bool = false

@onready var alarm: AudioStreamPlayer = $Alarm
@onready var timer_form: Node = $Body/TimerFormSpacing/TimerForm
@onready var timers_list: Node = $Body/TimersSpacing/TimersScroller/MarginContainer/TimersList

func _ready() -> void:
  for uid in config.timers:
    var timer = config.get_timer(uid)
    _add_timer(timer, uid)
  
  _sort_timers()
  
  timer_form.add_timer.connect(_add_timer)
  timer_form.update_timer_config.connect(_on_update_timer_config)


func _process(delta: float) -> void:
  if timers_completed: _render_completed(delta)


func _add_timer(timer_config: Dictionary = {}, uid: String = "") -> void:
  var create_args = [
    timer_config["color"],
    timer_config["name"],
    timer_config["hours"],
    timer_config["mins"],
    timer_config["secs"],
  ]
  if uid != "": create_args.push_back(uid)
  
  var timer: EggTimer = EggTimer.create.callv(create_args)
  if uid == "": config.set_timer(timer.uid, timer_config)
  
  timers_list.add_child(timer)
  
  _sort_timers()
  
  timer.completed_timer_stopped.connect(_on_completed_timer_stopped)
  timer.delete_timer.connect(_on_delete_timer)
  timer.edit_timer.connect(_on_edit_timer)
  timer.timer_complete.connect(_on_timer_complete)


func _on_completed_timer_stopped(uid: String) -> void:
  completed_timers.erase(uid)
  if completed_timers.size() == 0: timers_completed = false


func _on_delete_timer(uid: String) -> void:
  config.delete_timer(uid)


func _on_edit_timer(uid: String) -> void:
  timer_form.edit_timer(uid, config.get_timer(uid))


func _on_update_timer_config(uid: String, timer_config: Dictionary) -> void:
  config.set_timer(uid, timer_config)
  
  for timer: EggTimer in timers_list.get_children():
    if timer.uid == uid:
      timer.update(timer_config)
      break
  
  _sort_timers()


func _sort_timers() -> void:
  var timers: Array = timers_list.get_children()
  var sorted_timers: Array = []
  
  for timer in timers:
    sorted_timers.push_front(timer)
  
  sorted_timers.sort_custom(func(timer_a, timer_b):
    return timer_a.label.naturalnocasecmp_to(timer_b.label) < 0
  )
  
  for ndx in range(sorted_timers.size()):
    var timer: EggTimer = sorted_timers[ndx]
    timers_list.move_child(timer, ndx)






var blink: bool = false
var blink_secs = 0
var prev_blink_secs: int = 0

func _on_timer_complete(uid: String) -> void:
  completed_timers.push_front(uid)
  timers_completed = true


func _render_completed(delta: float) -> void:
  blink_secs += delta
  if int(blink_secs) != prev_blink_secs :
    prev_blink_secs = int(blink_secs)
    
    for timer: EggTimer in timers_list.get_children():
      if completed_timers.has(timer.uid):
        if int(blink_secs) % 2 == 0 :
          timer.time_display.add_theme_color_override("font_color", timer.timer_txt_color)
          alarm.play()
        else:
          timer.time_display.add_theme_color_override("font_color", timer.timer_txt_color_dim)
          alarm.stop()
