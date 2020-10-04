extends Node

var world = null		# Load at _ready world
var levels_unlocked = ["level_tutorial_1"] # Add basic levels or load unlocked
export (Array, PackedScene) var scenes
export (Array, Texture) var scene_thumbnails
export (Array, String) var scene_texts

func is_level_unlocked(level):
	return levels_unlocked.has(level.level_name)


func load_next_level():
	var preLevel = scenes[world.current_level_index]
	var actual_level_name = preLevel.instance().level_name
	var index_level = levels_unlocked.find(actual_level_name, 0)
	var next_level = index_level + 1
	if index_level >= -1 and next_level < levels_unlocked.size():
		world.load_new_level(index_level+1)
	else:
		for i in scenes.size():
			var lvl = scenes[i].instance()
			if not is_level_unlocked(lvl):
				levels_unlocked.append(lvl.level_name)
				world.load_new_level(i)
				break
			else:
				print("Level " + lvl.level_name + " is already unlocke")
		# TODO FINISH GAME

