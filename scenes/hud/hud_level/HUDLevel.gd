extends CanvasLayer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

signal restart_level
signal change_level
signal quit

func _ready():
	set_mute_button()


func _on_RestartLevel_pressed():
		emit_signal("restart_level")
		pass # Replace with function body.


func _on_ChangeLevel_pressed():
		emit_signal("change_level")
		pass # Replace with function body.


func _on_Quit_pressed():
		emit_signal("quit")
		pass # Replace with function body.

func set_mute_button():
	if not SoundManager.is_mute:
		$BackgroundMenu/Mute/Sprite.texture = load("res://assets/icons/icon_mute.png")
	else:
		$BackgroundMenu/Mute/Sprite.texture = load("res://assets/icons/icon_unmuted.png")

func _on_Mute_pressed():
	SoundManager.mute()
	set_mute_button()
