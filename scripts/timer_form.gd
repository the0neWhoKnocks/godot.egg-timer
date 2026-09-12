extends HBoxContainer

var color: String = Constants.DEFAULT__TIMER_COLOR
var ctrl_disabled: bool = true
var editing: bool = false

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
  
  ctrl_btn.text = Constants.ICON__PLUS
  #ctrl_btn.disabled = ctrl_disabled # TODO enable when inputs have values
  ctrl_btn.pressed.connect(_on_ctrl_button_pressed)

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
  # Create and add timer to list
  var timer = EggTimer.create(
    color,
    timer_name_input.text,
    hours_input.get_text(),
    minutes_input.get_text(),
    seconds_input.get_text(),
  )
  timers_list.add_child(timer)
  
  # Reset form
  color_picker_btn.color = Constants.DEFAULT__TIMER_COLOR
  timer_name_input.text = ""
  hours_input.value = 0
  minutes_input.value = 0
  seconds_input.get_text()
  
  # TODO: save new timer data to User's FS
