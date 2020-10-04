extends CanvasLayer

export (PackedScene) var level_item_scene

signal level_selected

func add_level_item(index_level, thumbnail, text_button):
    var level_item_instance = level_item_scene.instance()
    level_item_instance.set_thumbnail(thumbnail)
    level_item_instance.set_text_button(text_button)
    level_item_instance.index_level = index_level
    level_item_instance.connect("level_selected", self, "_on_LevelItem_pressed")
    $ScrollContainer/VBoxContainer.add_child(level_item_instance)
    
func _on_LevelItem_pressed(index_level):
    emit_signal("level_selected", index_level)    

