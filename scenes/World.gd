extends Node

export (Array, PackedScene) var scenes
export (PackedScene) var entry_point_scene
export (PackedScene) var hud_title_screen
export (PackedScene) var hud_level
export (PackedScene) var player
export var transition_time = 2.0

var current_level_instance
var previous_level_instance
var current_level_index
var current_hud_instance
var is_title_screen
var is_menu_escape_opened
var player_instance

func _ready():
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
    
    #Async loading menu escape HUD
    
    #Loading player
    player_instance = player.instance()
    player_instance.position = current_level_instance.get_node("PlayerStartPosition").global_position
    add_child(player_instance)
    
func _on_Level_selected(index_level):
    #Removing HUD (main screen)
    remove_child(current_hud_instance)
    
    #Store previous level but not deleting
    previous_level_instance = current_level_instance
    current_level_index = index_level
    current_level_instance = scenes[index_level].instance()
    current_level_instance.position = $LevelStartPosition.position
    add_child(current_level_instance)
    current_level_instance.hide()
    
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

func _on_Change_level():
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


func _on_TimerLoadHUDInstance_timeout():
    if is_title_screen:
        #Loading title screen HUD
        current_hud_instance = hud_title_screen.instance()
        add_child(current_hud_instance)
        current_hud_instance.connect("level_selected", self, "_on_Level_selected")
    else:
        current_hud_instance = hud_level.instance()
        add_child(current_hud_instance)
        current_hud_instance.connect("restart_level", self, "_on_Restart_level")
        current_hud_instance.connect("change_level", self, "_on_Change_level")
        current_hud_instance.connect("quit", self, "_on_Quit")

