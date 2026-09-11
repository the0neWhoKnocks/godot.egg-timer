extends HBoxContainer

const TIMER = preload("res://scenes/timer.tscn")

var ctrl_disabled: bool = true
var editing: bool = false

@onready var color_picker_btn: ColorPickerButton = $TimerColorPickerBtn
@onready var ctrl_btn: Button = $CtrlBtn
@onready var timers_list: VBoxContainer = %TimersList

func _ready() -> void:
  ctrl_btn.text = Constants.ICON__PLUS
  #ctrl_btn.disabled = ctrl_disabled # TODO enable when inputs have values
  ctrl_btn.pressed.connect(_on_ctrl_button_pressed)

func _on_color_picker_created() -> void:
  var picker: ColorPicker = color_picker_btn.get_picker()
  picker.sliders_visible = false
  picker.presets_visible = false
  picker.color_modes_visible = false
  picker.edit_alpha = false
  picker.scale = Vector2(0.75, 0.75)

func _on_ctrl_button_pressed() -> void:
  var timer = TIMER.instantiate() # TODO pass args (color, label, time)
  timers_list.add_child(timer)
