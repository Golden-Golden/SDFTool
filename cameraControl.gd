extends Node3D

@export var sensitivity: float = 0.6 

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _input(event):
	# Quit check (usually mapped to "ui_cancel" or "escape")
	if event.is_action_pressed("ui_cancel"):
		get_tree().quit()

	if event is InputEventMouseMotion:
		rotation.x+=(deg_to_rad(-event.relative.y * sensitivity))
		rotation.y+=(deg_to_rad(-event.relative.x * sensitivity))
