extends Area2D

onready var GameManager = $"/root/GameManager"

export(String) var type = "yellow"
var is_opened = false

func open_door():
	if not is_opened:
		is_opened = true
		$AnimationPlayer.play("open")
		yield($AnimationPlayer,"animation_finished")
		GameManager.load_next_level()
