extends Node

export (Array, PackedScene) var scenes
export (PackedScene) var entry_point_scene
export (PackedScene) var hud_title_screen
export (PackedScene) var hud_menu_escape

var current_level_instance
var current_hud_instance
var is_title_screen
var is_menu_escape_opened

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
    
func _on_Level_selected(index_level):
    remove_child(current_level_instance)
    remove_child(current_hud_instance)
    current_level_instance = scenes[index_level].instance()
    current_level_instance.position = $LevelStartPosition.position
    add_child(current_level_instance)
    is_title_screen = false


func _process(_delta):
    if Input.is_action_just_pressed("escape_menu") and not is_title_screen:
        remove_child(current_hud_instance)
        is_menu_escape_opened = not is_menu_escape_opened
        
        if (is_menu_escape_opened):
            current_hud_instance = hud_menu_escape.instance()
            add_child(current_hud_instance)
            current_hud_instance.connect("restart_level", self, "_on_Restart_level")
            current_hud_instance.connect("change_level", self, "_on_Change_level")
            current_hud_instance.connect("quit", self, "_on_Quit")

func _on_Restart_level():
    pass

func _on_Change_level():
    remove_child(current_level_instance)
    remove_child(current_hud_instance)
    pass

func _on_Quit():
    get_tree().quit()


