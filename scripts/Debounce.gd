class_name Debounce extends Resource

var _args: Array
var _fn: Callable
var _timer: Timer = null

func init(parent: Node, fn: Callable, delay: float) -> Callable:
  _fn = fn
  _timer = Timer.new()
  _timer.one_shot = true
  _timer.wait_time = delay
  parent.add_child(_timer)
  _timer.timeout.connect(_on_timeout)
  
  return func(...args):
    _args = args
    _timer.start() # any time `start` is called, it restarts the timer if it's running

func _on_timeout() -> void:
  _fn.call()
  if _fn.is_valid(): _fn.callv(_args)
