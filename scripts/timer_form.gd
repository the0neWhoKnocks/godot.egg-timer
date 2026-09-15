extends HBoxContainer

var color: String = Constants.DEFAULT__TIMER_COLOR
var ctrl_disabled: bool = true
var uid: String = ""

@onready var color_picker_btn: ColorPickerButton = $TimerColorPickerBtn
@onready var ctrl_btn: Button = $CtrlBtn
@onready var hours_input: PaddedSpinBox = $HoursInput
@onready var minutes_input: PaddedSpinBox = $MinutesInput
@onready var seconds_input: PaddedSpinBox = $SecondsInput
@onready var timer_name_input: LineEdit = $TimerNameInput
@onready var timers_list: VBoxContainer = %TimersList

func _ready() -> void:
  color_picker_btn.color = color
  color_picker_btn.color_changed.connect(_on_color_changed)
  
  _update_ctrl_btn()
  #ctrl_btn.disabled = ctrl_disabled # TODO enable when inputs have values
  ctrl_btn.pressed.connect(_on_ctrl_button_pressed)
  
  for _uid in App.config.timers:
    var timer = App.config.get_timer(_uid)
    _add_timer(_uid, timer)
  
  _sort_timers()
  
  App.edit_timer.connect(_on_edit)
  
  
func _add_timer(_uid: String = "", timer_config: Dictionary = {}) -> EggTimer:
  var timer: EggTimer
  
  if _uid != "":
    timer = EggTimer.create(
      timer_config["color"],
      timer_config["name"],
      timer_config["hours"],
      timer_config["mins"],
      timer_config["secs"],
      _uid,
    )
  else:
    timer = EggTimer.create(
      color,
      timer_name_input.text,
      hours_input.get_text(),
      minutes_input.get_text(),
      seconds_input.get_text(),
    )
  
  timers_list.add_child(timer)
  return timer


func _on_color_changed(col: Color) -> void:
  color = col.to_html(false)


func _on_color_picker_created() -> void:
  var picker: ColorPicker = color_picker_btn.get_picker()
  picker.sliders_visible = false
  picker.presets_visible = false
  picker.color_modes_visible = false
  picker.edit_alpha = false
  picker.scale = Vector2(0.75, 0.75)


func _on_ctrl_button_pressed() -> void:
  var _uid: String
  var changed: bool = false
  var payload: Dictionary = {}
  
  if uid == "":
    # Create and add timer to list
    var timer = _add_timer()
    _uid = timer.uid
    payload = {
      "color": timer.color,
      "hours": timer.hours,
      "mins": timer.minutes,
      "name": timer.label,
      "secs": timer.seconds,
    }
  else:
    _uid = uid
    payload = {
      "color": color_picker_btn.color.to_html(),
      "hours": hours_input.value,
      "mins": minutes_input.value,
      "name": timer_name_input.text,
      "secs": seconds_input.value,
    }
    
  # Reset form
  color_picker_btn.color = Constants.DEFAULT__TIMER_COLOR
  timer_name_input.text = ""
  hours_input.value = 0
  minutes_input.value = 0
  seconds_input.value = 0
  if uid != "":
    changed = true
    uid = ""
    _update_ctrl_btn()
  
  App.config.set_timer(_uid, payload, changed)
  _sort_timers()


func _on_edit(_uid: String) -> void:
  uid = _uid
  
  var timer_conf: Dictionary = App.config.get_timer(uid)
  
  color_picker_btn.color = timer_conf["color"]
  timer_name_input.text = timer_conf["name"]
  hours_input.value = timer_conf["hours"]
  minutes_input.value = timer_conf["mins"]
  seconds_input.value = timer_conf["secs"]
  
  _update_ctrl_btn()


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
  


func _update_ctrl_btn() -> void:
  if uid == "":
    ctrl_btn.text = Constants.ICON__PLUS
    Utils.remove_btn_style_override(ctrl_btn)
  else:
    ctrl_btn.text = Constants.ICON__SAVE
    Utils.add_btn_style_override(ctrl_btn, "#3e9881")
