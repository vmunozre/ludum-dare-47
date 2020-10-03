extends Area2D

export(String) var type = "yellow"
var is_opened = false

func open_door():
	if not is_opened:
		is_opened = true
		$AnimationPlayer.play("open")
		yield($AnimationPlayer,"animation_finished")
		$AnimationPlayer.play("opened")
		yield($AnimationPlayer,"animation_finished")
