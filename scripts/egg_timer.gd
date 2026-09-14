class_name EggTimer extends PanelContainer

const EGG_TIMER = preload("res://scenes/egg_timer.tscn")

var blink: bool = false
var blink_secs = 0
var color: String = "#000000"
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
var prev_blink_secs: int = 0
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
@onready var time_display: Label = $Spacing/Row/TimeDisplay
@onready var timer_name: Label = $Spacing/Row/TimerName


# Constructor
static func create(
  _color: String,
  _label: String,
  _hours: int,
  _minutes: int,
  _seconds: int,
) -> EggTimer:
  var timer = EGG_TIMER.instantiate()
  timer.color = _color
  timer.label = _label
  timer.hours = _hours
  timer.minutes = _minutes
  timer.seconds = _seconds
  timer.uid = Utils.gen_uuid4()
  return timer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
  var chip_style = color_chip.get_theme_stylebox("panel").duplicate()
  chip_style.bg_color = Color(color)
  color_chip.add_theme_stylebox_override("panel", chip_style)
  
  update_ctrl_styles()
  timer_txt_color = time_display.get_theme_color("font_color")
  timer_txt_color_dim = Color(timer_txt_color, 0.5)
  ctrl_btn.pressed.connect(_on_ctrl_btn_press)
  
  update_display(hours, minutes, seconds)
  timer_name.text = label
  delete_btn.text = Constants.ICON__DELETE
  edit_btn.text = Constants.ICON__EDIT
  
  total_seconds = (hours * 3600) + (minutes * 60) + seconds


func _on_ctrl_btn_press() -> void:
  timer_running = !timer_running
  update_ctrl_styles()
  
  if !timer_running :
    blink = false
    blink_secs = 0
    elapsed_seconds = 0
    prev_blink_secs = 0
    time_display.add_theme_color_override("font_color", timer_txt_color)
    update_display(hours, minutes, seconds)


func _process(delta: float) -> void:
  render_timer(delta)
  render_blink(delta)


func render_blink(delta: float) -> void:
  if blink :
    blink_secs += delta
    if int(blink_secs) != prev_blink_secs :
      prev_blink_secs = int(blink_secs)
      if int(blink_secs) % 2 == 0 :
        time_display.add_theme_color_override("font_color", timer_txt_color)
      else:
        time_display.add_theme_color_override("font_color", timer_txt_color_dim)


func render_timer(delta: float) -> void:
  if timer_running && !blink :
    elapsed_seconds += delta
    var remaining_seconds = int(total_seconds - elapsed_seconds)
    var secs = remaining_seconds % 60
    var mins = (remaining_seconds / 60) % 60
    var hrs = mins / 60
    var combined = hrs + mins + secs
    
    if combined > 0 && prev_time != combined :
      prev_time = combined
      update_display(hrs, mins, secs)
    elif combined == 0 :
      blink = true
      update_display(hrs, mins, secs)


func update_ctrl_styles() -> void:
  var styles = ctrl_styles["stop"] if timer_running else ctrl_styles["play"]
  var style1 = ctrl_btn.get_theme_stylebox("normal").duplicate()
  var style2 = ctrl_btn.get_theme_stylebox("pressed").duplicate()
  style1.bg_color = Color(styles["color"])
  style2.bg_color = Color(str(styles["color"], "CC")) # add opacity
  ctrl_btn.add_theme_stylebox_override("normal", style1)
  ctrl_btn.add_theme_stylebox_override("focus", style2)
  ctrl_btn.add_theme_stylebox_override("hover", style2)
  ctrl_btn.add_theme_stylebox_override("pressed", style2)
  ctrl_btn.text = styles["icon"]


func update_display(hrs: int, mins: int, secs: int) -> void:
  time_display.text = "{hours}:{minutes}:{seconds}".format({
    "hours": str(hrs).pad_zeros(2),
    "minutes": str(mins).pad_zeros(2),
    "seconds": str(secs).pad_zeros(2),
  })
