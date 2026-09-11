extends PanelContainer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
  var ctrlBtn: Button = $Spacing/Row/CtrlBtn
  var deleteBtn: Button = $Spacing/Row/DeleteBtn
  var editBtn: Button = $Spacing/Row/EditBtn
  
  ctrlBtn.text = Constants.ICON__PLAY
  deleteBtn.text = Constants.ICON__DELETE
  editBtn.text = Constants.ICON__EDIT

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
  #pass
