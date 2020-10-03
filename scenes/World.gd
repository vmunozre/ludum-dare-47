extends Node

export (PackedScene) var LevelTutorial
export (PackedScene) var Player

func _ready():
	var level_tutorial = LevelTutorial.instance()
	level_tutorial.position = $LevelStartPosition.position
	add_child(level_tutorial)
