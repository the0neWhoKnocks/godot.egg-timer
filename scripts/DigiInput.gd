@tool
@icon("res://editor/icons/digit_input.svg")
class_name DigiInput extends PanelContainer

signal value_changed(val: int)

var add_down: bool = false
var speed_up_inc: float = 0
var sub_down: bool = false
var total_digits: int

## Color of the up and down buttons.
@export var btn_color: Color = Color("#3c3c3c"):
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
## Thickness of the border.
@export var border_size: int = 1:
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
## How round the corners are.
@export var corner_radius: int = 10:
  set(new_radius):
    corner_radius = new_radius
    Utils.update_stylebox(
      [Utils.StyleBoxState.NORMAL, Utils.StyleBoxState.PANEL],
      [
        [self, ["corner_radius_top_left", "corner_radius_bottom_left", "corner_radius_top_right", "corner_radius_bottom_right"]],
        [sub_btn, ["corner_radius_top_left", "corner_radius_bottom_left"]],
        [add_btn, ["corner_radius_top_right", "corner_radius_bottom_right"]],
      ],
      corner_radius,
    )
## The highest value. This also determines how many zeros the visual value gets padded with.
@export var max_value: int = 60:
  set(max):
    max_value = max
    total_digits = str(max_value).length()
    if num_input:
      num_input.max_length = max_value
      num_input.add_theme_constant_override("minimum_character_width", total_digits)
      _set_text(value)
## The lowest value.
@export var min_value: int = 0
## How much the value goes up with each tick.
@export var step: int = 1
## Starts with this value.
@export var value: int = 0:
  set(new_val):
    if wrap_around:
      if new_val > max_value:
        value = (max_value - new_val) + 1
      elif new_val < min_value:
        value = max_value - (min_value - new_val) + 1
      else:
        value = new_val
    else:
      value = clamp(new_val, min_value, max_value)
      if value == min_value: sub_btn.disabled = true
      elif value == max_value: add_btn.disabled = true
      elif add_btn.disabled || sub_btn.disabled:
        add_btn.disabled = false
        sub_btn.disabled = false
    
    if num_input && num_input.text != str(value):
      num_input.text = str(value)
      _set_text(value)
      value_changed.emit(value)
## If the value goes over the [b][color=orange]Max Value[/color][/b] it'll wrap to the [b][color=yellow]Min Value[/color][/b] and visa versa.
@export var wrap_around: bool = true

@onready var add_btn: Button = $Row/AddBtn
@onready var num_input: LineEdit = $Row/NumInput
@onready var sub_btn: Button = $Row/SubBtn


func _gui_input(ev: InputEvent) -> void:
  if ev is InputEventMouseButton and ev.pressed:
    if ev.button_index == MOUSE_BUTTON_WHEEL_UP:
      _on_increase()
    elif ev.button_index == MOUSE_BUTTON_WHEEL_DOWN:
      _on_decrease()


func _ready() -> void:
  Utils.dupe_stylebox(self, "panel", ["panel"])
  
  sub_btn.text = Constants.ICON__MINUS
  Utils.dupe_stylebox(sub_btn, "normal", ["disabled", "focus", "hover", "normal", "pressed"])
  sub_btn.button_down.connect(_on_decrease_down)
  sub_btn.button_up.connect(_on_decrease_up)
  sub_btn.pressed.connect(_on_decrease)
  
  Utils.dupe_stylebox(num_input, "normal", ["normal"])
  num_input.text_submitted.connect(_on_text_change)
  num_input.focus_exited.connect(func(): _on_text_change(num_input.text))
  _set_text(value)
  
  add_btn.text = Constants.ICON__PLUS
  Utils.dupe_stylebox(add_btn, "normal", ["disabled", "focus", "hover", "normal", "pressed"])
  add_btn.button_down.connect(_on_increase_down)
  add_btn.button_up.connect(_on_increase_up)
  add_btn.pressed.connect(_on_increase)
  
  if !Engine.is_editor_hint(): # TODO: gotta be a better way to do this
    btn_color = btn_color
    border_size = border_size
    corner_radius = corner_radius
    max_value = max_value
    min_value = min_value
    step = step
    value = value


func _on_decrease() -> void:
  value -= step
  _set_text(value)

func _on_decrease_down() -> void:
  speed_up_inc = 0
  sub_down = true
  
func _on_decrease_up() -> void:
  sub_down = false


func _on_increase() -> void:
  value += step
  _set_text(value)

func _on_increase_down() -> void:
  speed_up_inc = 0
  add_down = true

func _on_increase_up() -> void:
  add_down = false


func _on_text_change(txt: String) -> void:
  value = int(txt)
  _set_text(value)


func _process(delta: float) -> void:
  if add_down: _speed_up_inc(_on_increase, delta)
  elif sub_down: _speed_up_inc(_on_decrease, delta)


func _set_text(txt: int) -> void:
  num_input.text = str(txt).pad_zeros(total_digits)


func _speed_up_inc(fn: Callable, delta) -> void:
  var pad = 0.2 if speed_up_inc > 10 else 0.1 if speed_up_inc > 5 else 0.05
  var new_inc = int(speed_up_inc + delta + pad)
  
  if new_inc > speed_up_inc: fn.call()
  
  speed_up_inc += delta + pad
