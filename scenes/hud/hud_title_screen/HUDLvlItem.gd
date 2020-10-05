extends MarginContainer

var index_level
signal level_selected

func set_text_button(text):
	$TextureButton/Label.text = text

func _on_TextureButton_pressed():
	emit_signal("level_selected", index_level)

