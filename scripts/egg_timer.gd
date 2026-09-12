class_name EggTimer extends PanelContainer

const EGG_TIMER = preload("res://scenes/egg_timer.tscn")

var color: String
var hours: int
var label: String
var minutes: int
var seconds: int

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
  return timer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
  var chip_style = color_chip.get_theme_stylebox("panel").duplicate()
  chip_style.bg_color = Color(color)
  color_chip.add_theme_stylebox_override("panel", chip_style)
  
  ctrl_btn.text = Constants.ICON__PLAY
  update_display()
  timer_name.text = label
  delete_btn.text = Constants.ICON__DELETE
  edit_btn.text = Constants.ICON__EDIT

func update_display() -> void:
  time_display.text = "{hours}:{minutes}:{seconds}".format({
    "hours": str(hours).pad_zeros(2),
    "minutes": str(minutes).pad_zeros(2),
    "seconds": str(seconds).pad_zeros(2),
  })

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
  #pass
