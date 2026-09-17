@tool
class_name DigiInput extends HBoxContainer

signal value_changed(val: int)

@export var max_value: int = 60 
@export var min_value: int = 0 
@export var step: int = 1
@export var total_digits: int = 2:  # Number of digits to pad with zeros
  set(new_total):
    total_digits = new_total
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
