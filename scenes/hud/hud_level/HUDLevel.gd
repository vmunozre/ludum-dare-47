extends CanvasLayer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

signal restart_level
signal change_level
signal quit

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#    pass


func _on_RestartLevel_pressed():
	emit_signal("restart_level")
	pass # Replace with function body.


func _on_ChangeLevel_pressed():
	emit_signal("change_level")
	pass # Replace with function body.


func _on_Quit_pressed():
	emit_signal("quit")
	pass # Replace with function body.
