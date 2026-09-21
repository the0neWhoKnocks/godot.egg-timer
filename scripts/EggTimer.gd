class_name EggTimer extends PanelContainer

const EGG_TIMER = preload("res://scenes/egg_timer.tscn")

signal completed_timer_stopped(uid: String)
signal delete_timer(uid: String)
signal edit_timer(uid: String)
signal timer_complete(uid: String)

var color: String = "#000000"
var completed: bool = false
var ctrl_styles: Dictionary = {
  "play": {
    "color": "#3e9881",
    "icon": Constants.ICON__PLAY,
  },
  "stop": {
    "color": "#f34755",
    "icon": Constants.ICON__STOP,
  },
}
var elapsed_seconds: float = 0
var hours: int = 0
var label: String = "TIMER_NAME"
var minutes: int = 0
var prev_time: int = 0
var seconds: int = 0
var timer_running: bool = false
var timer_txt_color: Color
var timer_txt_color_dim: Color
var total_seconds: int = 0
var uid: String

@onready var color_chip: Panel = $Spacing/Row/ColorChip
@onready var ctrl_btn: Button = $Spacing/Row/CtrlBtn
@onready var delete_btn: Button = $Spacing/Row/DeleteBtn
@onready var edit_btn: Button = $Spacing/Row/EditBtn
@onready var time_display: Label = $Spacing/Row/TimeDisplayContainer/TimeDisplay
@onready var timer_name: Label = $Spacing/Row/TimerName


# Constructor
static func create(
  _color: String,
  _label: String,
  _hours: int,
  _minutes: int,
  _seconds: int,
  _uid: String = "",
) -> EggTimer:
  var timer = EGG_TIMER.instantiate()
  timer.color = _color
  timer.label = _label
  timer.hours = _hours
  timer.minutes = _minutes
  timer.seconds = _seconds
  timer.uid = _uid if _uid != "" else Utils.gen_uuid4()
  return timer


func _process(delta: float) -> void:
  if timer_running && !completed: _render_timer(delta)


func _ready() -> void:
  _render_ui()
  
  ctrl_btn.pressed.connect(_on_ctrl_btn_press)
  edit_btn.pressed.connect(_on_edit_btn_press)
  delete_btn.pressed.connect(_on_delete_btn_press)


func _on_ctrl_btn_press() -> void:
  timer_running = !timer_running
  _update_ctrl_styles()
  
  if completed:
    completed = false
    completed_timer_stopped.emit(uid)
  
  if !timer_running:
    elapsed_seconds = 0
    prev_time = 0
    time_display.add_theme_color_override("font_color", timer_txt_color)
    _update_display(hours, minutes, seconds)


func _on_delete_btn_press() -> void:
  delete_timer.emit(uid)
  queue_free()


func _on_edit_btn_press() -> void:
  edit_timer.emit(uid)


func _render_timer(delta: float) -> void:
  elapsed_seconds += delta
  var remaining_seconds = int(total_seconds - elapsed_seconds)
  var secs = remaining_seconds % 60
  var mins = (remaining_seconds / 60) % 60
  var hrs = (remaining_seconds / 3600) % 60
  var combined = hrs + mins + secs
  
  if combined > 0 && prev_time != combined:
    prev_time = combined
    _update_display(hrs, mins, secs)
  elif combined == 0:
    completed = true
    _update_display(hrs, mins, secs)
    timer_complete.emit(uid)


func _render_ui() -> void:
  var chip_style: StyleBox = color_chip.get_theme_stylebox("panel").duplicate()
  chip_style.bg_color = Color(color)
  color_chip.add_theme_stylebox_override("panel", chip_style)
  
  _update_ctrl_styles()
  timer_txt_color = time_display.get_theme_color("font_color")
  timer_txt_color_dim = Color(timer_txt_color, 0.5)
  
  _update_display(hours, minutes, seconds)
  timer_name.text = label
  edit_btn.text = Constants.ICON__EDIT
  delete_btn.text = Constants.ICON__DELETE
  
  total_seconds = (hours * 3600) + (minutes * 60) + seconds


func _update_ctrl_styles() -> void:
  var styles = ctrl_styles["stop"] if timer_running else ctrl_styles["play"]
  Utils.add_btn_style_override(ctrl_btn, styles["color"])
  ctrl_btn.text = styles["icon"]


func _update_display(hrs: int, mins: int, secs: int) -> void:
  time_display.text = "{hours}:{minutes}:{seconds}".format({
    "hours": str(hrs).pad_zeros(2),
    "minutes": str(mins).pad_zeros(2),
    "seconds": str(secs).pad_zeros(2),
  })


func update(conf_data: Dictionary) -> void:
  color = conf_data["color"]
  label = conf_data["name"]
  hours = conf_data["hours"]
  minutes = conf_data["mins"]
  seconds = conf_data["secs"]
  _render_ui()
