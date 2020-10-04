extends MarginContainer

var index_level

signal level_selected

func set_thumbnail(new_texture):
	$HBoxContainer/MarginThumbnail/Thumbnail.texture = new_texture

func set_text_button(new_text_button):
	$HBoxContainer/MarginButton/Button.text = new_text_button    

func _on_Button_pressed():
	emit_signal("level_selected", index_level)
