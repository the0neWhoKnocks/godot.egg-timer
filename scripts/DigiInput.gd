@tool
class_name DigiInput extends HBoxContainer

signal value_changed(val: int)

@export var btn_color: Color = Color(Constants.BTN_COLOR__DEFAULT):
  set(new_clr):
    btn_color = new_clr
    Utils.update_stylebox(
      [Utils.StyleBoxState.NORMAL],
      [
        [sub_btn, ["bg_color"]],
        [add_btn, ["bg_color"]],
      ],
      btn_color,
    )
@export var border_size: int = 2:
   set(new_size):
    border_size = new_size
    Utils.update_stylebox(
      [Utils.StyleBoxState.NORMAL],
      [
        [sub_btn, ["border_width_left", "border_width_top", "border_width_bottom"]],
        [num_input, ["border_width_top", "border_width_bottom"]],
        [add_btn, ["border_width_top", "border_width_right", "border_width_bottom"]],
      ],
      border_size,
    )
@export var corner_radius: int = 10:
  set(new_radius):
    corner_radius = new_radius
    Utils.update_stylebox(
      [Utils.StyleBoxState.NORMAL],
      [
        [sub_btn, ["corner_radius_top_left", "corner_radius_bottom_left"]],
        [add_btn, ["corner_radius_top_right", "corner_radius_bottom_right"]],
      ],
      corner_radius,
    )
@export var max_value: int = 60 
@export var min_value: int = 0 
@export var step: int = 1
@export var total_digits: int = 2:  # Number of digits to pad with zeros
  set(new_total):
    total_digits = new_total
    num_input.max_length = total_digits
    num_input.add_theme_constant_override("minimum_character_width", total_digits)
    _set_text(value)
@export var value: int = 0:
  set(new_val):
    value = clamp(new_val, min_value, max_value)
    if num_input and not num_input.text == str(value):
      num_input.text = str(value)
      _set_text(value)
      value_changed.emit(value)

@onready var add_btn: Button = $AddBtn
@onready var num_input: LineEdit = $NumInput
@onready var sub_btn: Button = $SubBtn

func _ready() -> void:
  add_btn.pressed.connect(_on_increase)
  sub_btn.pressed.connect(_on_decrease)
  
  num_input.text_submitted.connect(_on_text_change)
  num_input.focus_exited.connect(func(): _on_text_change(num_input.text))
  _set_text(value)


func _on_decrease() -> void:
  value -= step
  _set_text(value)


func _on_increase() -> void:
  value += step
  _set_text(value)


func _on_text_change(txt: String) -> void:
  value = int(txt)
  _set_text(value)


func _set_text(txt: int) -> void:
  num_input.text = str(txt).pad_zeros(total_digits)

## Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
  #pass
