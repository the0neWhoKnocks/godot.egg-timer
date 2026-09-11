class_name PaddedSpinBox extends SpinBox

@export var total_digits: int = 2  # Number of digits to pad with zeros

func _ready() -> void:
  # Connect signals. `value` is for normal changes, but the `focus` events are needed otherwise the
  # formatting gets removed when the User clicks into the input.
  value_changed.connect(_on_value_changed, CONNECT_DEFERRED)
  get_line_edit().focus_entered.connect(_on_focus, CONNECT_DEFERRED)
  get_line_edit().focus_exited.connect(_on_focus, CONNECT_DEFERRED)
  
  # Hide the caret
  get_line_edit().add_theme_color_override("caret_color", Color(0, 0, 0, 0))
  
  # Format initial value
  _update_display(value)

func _on_value_changed(val: float) -> void:
  _update_display(val)

func _on_focus() -> void:
  _update_display(value)

func _update_display(val: float) -> void:
  # NOTE: I tried using `get_line_edit().text = ` but the formatting wouldn't consistently be
  # applied. Once I switched to `call_deferred` it was consistently formatted. Oddly, I have to use
  # it in combination with `CONNECT_DEFERRED`, otherwise I get the same inconsistent result.
  get_line_edit().call_deferred(&"set_text", str(int(val)).pad_zeros(total_digits))
