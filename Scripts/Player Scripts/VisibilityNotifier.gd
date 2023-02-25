extends VisibleOnScreenNotifier2D


@onready var visibility_notifier := get_node("/root/World3D/Player/VisibleOnScreenNotifier2D")

func _ready() -> void:
	var _error_code = visibility_notifier.connect("screen_entered",Callable(self,"show"))
	_error_code = visibility_notifier.connect("screen_exited",Callable(self,"hide"))
	visible = false


func _on_VisibilityNotifier2D_screen_entered():
	visible = true


func _on_VisibilityNotifier2D_screen_exited():
	visible = false
