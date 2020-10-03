extends CanvasLayer

signal level_selected

func _on_ButtonLevel0_pressed():
    emit_signal("level_selected", 0)    

func _on_ButtonLevel1_pressed():
    emit_signal("level_selected", 1)

func _on_ButtonLevel2_pressed():
    emit_signal("level_selected", 2)
