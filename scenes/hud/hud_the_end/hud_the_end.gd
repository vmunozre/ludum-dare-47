extends Node

var TYPE_ABOUT = "about"
var TYPE_THE_END = "the_end"
var type = TYPE_THE_END

func _ready():
	$TextureButton.hide()
	change_title()
	$AnimationPlayer.play("load")
	yield($AnimationPlayer,"animation_finished")
	$TextureButton.show()

func _on_TextureButton_pressed():
	GameManager.world.go_home()

func change_title():
	if type == TYPE_ABOUT:
		$TheEnd.hide()
		$About.show()
	if type == TYPE_THE_END:
		$About.hide()
		$TheEnd.show()
