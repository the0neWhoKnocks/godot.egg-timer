class_name TimerForm extends HBoxContainer

signal add_timer(timer_config: Dictionary, uid: String)
signal update_timer_config(timer_config: Dictionary, changed: bool)

var color: String = Constants.DEFAULT__TIMER_COLOR
var ctrl_disabled: bool = true
var debounced_validate: Callable
var input_debounce: Debounce
var uid: String = ""

@onready var color_picker_btn: ColorPickerButton = $TimerColorPickerBtn
@onready var ctrl_btn: Button = $CtrlBtn
@onready var hours_input: DigiInput = $HoursInput
@onready var minutes_input: DigiInput = $MinutesInput
@onready var seconds_input: DigiInput = $SecondsInput
@onready var timer_name_input: LineEdit = $TimerNameInput
@onready var timers_list: VBoxContainer = %TimersList

func _ready() -> void:
  input_debounce = Debounce.new()
  debounced_validate = input_debounce.init(self, _validate, 0.1)
  
  color_picker_btn.color = color
  color_picker_btn.color_changed.connect(_on_color_changed)
  
  _update_ctrl_btn()
  ctrl_btn.pressed.connect(_on_ctrl_button_pressed)
  
  timer_name_input.text_changed.connect(debounced_validate)
  hours_input.value_changed.connect(debounced_validate)
  minutes_input.value_changed.connect(debounced_validate)
  seconds_input.value_changed.connect(debounced_validate)


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
  var payload: Dictionary = {
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
  
  if uid == "": add_timer.emit(payload)
  else:
    update_timer_config.emit(uid, payload)
    uid = ""
    _update_ctrl_btn()


func _update_ctrl_btn() -> void:
  if uid == "":
    ctrl_btn.text = Constants.ICON__PLUS
    Utils.remove_btn_style_override(ctrl_btn)
  else:
    ctrl_btn.text = Constants.ICON__SAVE
    Utils.add_btn_style_override(ctrl_btn, "#3e9881")
  
  _validate()


func _validate(..._args) -> void:
  if timer_name_input.text != "" && hours_input.value + minutes_input.value + seconds_input.value > 0:
    ctrl_btn.disabled = false
  else:
    ctrl_btn.disabled = true


func edit_timer(_uid: String, timer_conf: Dictionary) -> void:
  uid = _uid
  color_picker_btn.color = timer_conf["color"]
  timer_name_input.text = timer_conf["name"]
  hours_input.value = timer_conf["hours"]
  minutes_input.value = timer_conf["mins"]
  seconds_input.value = timer_conf["secs"]
  
  _update_ctrl_btn()
