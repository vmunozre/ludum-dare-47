extends Node

var key_packed = preload("res://entities/key/Key.tscn")

# export (Array, PackedScene) var scenes
# export (Array, Texture) var scene_thumbnails
# export (Array, String) var scene_texts
export (PackedScene) var entry_point_scene
export (PackedScene) var hud_title_screen
export (PackedScene) var hud_level
export (PackedScene) var player
export (PackedScene) var hud_introduction
export (Array, Texture) var introduction_slides
export var transition_time = 2.0
export var is_cheat_skip_introduction = true

onready var GameManager = $"/root/GameManager"

var current_level_instance
var previous_level_instance
var current_level_index
var current_hud_instance
var is_title_screen
var is_menu_escape_opened
var player_instance

func _ready():
		if is_cheat_skip_introduction:
				_on_Introduction_finished()
				return
		current_hud_instance = hud_introduction.instance()
		add_child(current_hud_instance)
		current_hud_instance.connect("introduction_finished", self, "_on_Introduction_finished")
		current_hud_instance.create_carousel(introduction_slides)


func _on_Introduction_finished():
		remove_child(current_hud_instance)
		#Starting game
		
		GameManager.world = self
		$Background/Planets.emitting = true
		$Background/Stars.emitting = true
		#Loading title screen "level"
		current_level_instance = entry_point_scene.instance()
		current_level_instance.position = $LevelStartPosition.position
		add_child(current_level_instance)
		is_title_screen = true
		
		#Loading title screen HUD
		current_hud_instance = hud_title_screen.instance()
		add_child(current_hud_instance)
		current_hud_instance.connect("level_selected", self, "_on_Level_selected")
		is_menu_escape_opened = false
		
		#Loading all levels
		load_levels()


		
		#Async loading menu escape HUD
		
		#Loading player
		player_instance = player.instance()
		player_instance.position = current_level_instance.get_node("PlayerStartPosition").global_position
		add_child(player_instance)

func load_new_level(index_level):
		player_instance.toggle_light(false)
		_on_Level_selected(index_level)

func _on_Level_selected(index_level):
		#Removing HUD (main screen)
		remove_child(current_hud_instance)
		
		#Store previous level but not deleting
		previous_level_instance = current_level_instance
		current_level_index = index_level
		current_level_instance = GameManager.scenes[index_level].instance()
		current_level_instance.position = $LevelStartPosition.position
		add_child(current_level_instance)
		current_level_instance.hide()
		
		toggle_light_player()
		player_instance.reset_player()
		#player_instance.position = get_node("Level/PlayerStartPosition").global_position
		player_instance.start_transition_between_levels(current_level_instance.get_node("PlayerStartPosition").global_position, transition_time)
		is_title_screen = false
		$TimerLoadLevelInstance.wait_time = transition_time / 2
		$TimerLoadLevelInstance.start()
		$TimerLoadHUDInstance.wait_time = transition_time
		$TimerLoadHUDInstance.start()
		


func _on_Restart_level():
		player_instance.reset_player()
		#player_instance.position = current_level_instance.get_node("PlayerStartPosition").global_position
		player_instance.start_transition_between_levels(current_level_instance.get_node("PlayerStartPosition").global_position, transition_time, 3)
		 
		pass

func toggle_light_player():
		if current_level_instance != null and current_level_instance.get("type") != null:
				if current_level_instance.type == "dark":
						player_instance.toggle_light(true)
				else:
						player_instance.toggle_light(false)

func go_home():
		player_instance.toggle_light(false)
		_on_Change_level()

func add_key():
	var key_instance = key_packed.instance()
	var curr_key_position = current_level_instance.find_node("KeyPosition")
	if curr_key_position != null:
		curr_key_position.add_child(key_instance)

func _on_Change_level():
		toggle_light_player()
		previous_level_instance = current_level_instance
		
		#remove_child(current_level_instance)
		remove_child(current_hud_instance)
		
		#Loading title screen "level"
		current_level_instance = entry_point_scene.instance()
		current_level_instance.position = $LevelStartPosition.position
		add_child(current_level_instance)
		current_level_instance.hide()
		is_title_screen = true
		
		is_menu_escape_opened = false
		
		player_instance.reset_player()
		#player_instance.position = get_node("Level/PlayerStartPosition").global_position
		#player_instance.position = get_node("Level/PlayerStartPosition").global_position    
		player_instance.start_transition_between_levels(current_level_instance.get_node("PlayerStartPosition").global_position, transition_time)
		
		$TimerLoadLevelInstance.wait_time = transition_time / 2
		$TimerLoadLevelInstance.start()
		$TimerLoadHUDInstance.wait_time = transition_time
		$TimerLoadHUDInstance.start()

func _on_Quit():
		get_tree().quit()


func _on_TimerLoadLevelInstance_timeout():
		remove_child(previous_level_instance)
		current_level_instance.show()

func load_levels():
		for i in GameManager.scenes.size():
				var lvl = GameManager.scenes[i].instance()
				if GameManager.is_level_unlocked(lvl):
						current_hud_instance.add_level_item(i, GameManager.scene_thumbnails[i], GameManager.scene_texts[i])
				lvl.queue_free()
func _on_TimerLoadHUDInstance_timeout():
		if is_title_screen:
				#Loading title screen HUD
				current_hud_instance = hud_title_screen.instance()
				add_child(current_hud_instance)
				current_hud_instance.connect("level_selected", self, "_on_Level_selected")
				#Loading all levels
				load_levels()
		else:
				current_hud_instance = hud_level.instance()
				add_child(current_hud_instance)
				current_hud_instance.connect("restart_level", self, "_on_Restart_level")
				current_hud_instance.connect("change_level", self, "_on_Change_level")
				current_hud_instance.connect("quit", self, "_on_Quit")

