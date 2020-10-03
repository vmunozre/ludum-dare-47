extends Area2D

signal key_taken

export(String) var type = "yellow"

func _on_Key_body_entered(body):
	if (body.is_in_group("player")):
		hide()
		emit_signal("key_taken", type)
		queue_free()
