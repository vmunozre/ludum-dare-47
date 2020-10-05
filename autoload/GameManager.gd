extends Node

var world = null	
var levels_unlocked = ["tutorial_1"] # Add basic levels or load unlocked
export (Array, PackedScene) var scenes
export (Array, String) var scene_texts
export (bool) var is_cheat_all_levels_activated
export (String) var LAST_LEVEL_NAME = "basic_5"

var is_all_unlocked = false

func is_level_unlocked(level):
	if is_cheat_all_levels_activated:
		return true
	return levels_unlocked.has(level.level_name)

func unlocked_all_levels():
	is_all_unlocked = true
	is_cheat_all_levels_activated = true
	levels_unlocked = Array()
	for i in scenes.size():
		print("SCENE: " + str(i))
		var lvl = scenes[i].instance()
		var lvl_name = str(lvl.level_name)
		print("LVL NAME: " + lvl_name)
		levels_unlocked.append(lvl_name)
		
		lvl.queue_free()
	print(str(levels_unlocked))

func load_next_level():
	var preLevel = scenes[world.current_level_index]
	var preLvlInstance = preLevel.instance()
	var actual_level_name = preLvlInstance.level_name
	if not is_all_unlocked and actual_level_name == LAST_LEVEL_NAME:
		unlocked_all_levels()
		world.load_the_end()
	else:
		var index_level = levels_unlocked.find(actual_level_name, 0)
		var next_level = index_level + 1
		if index_level >= -1 and next_level < levels_unlocked.size():
			world.load_new_level(next_level)
			preLvlInstance.queue_free()
			return
		else:
			for i in scenes.size():
				var lvl = scenes[i].instance()
				if not is_level_unlocked(lvl):
					levels_unlocked.append(lvl.level_name)
					world.load_new_level(i)
					lvl.queue_free()
					return
				else:
					lvl.queue_free()
					print("Level " + lvl.level_name + " is already unlocke")
		world.load_the_end()

