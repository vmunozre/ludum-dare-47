extends Path2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export var speed = 100
export var rotation_rate = 0.5

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _process(delta):
	$PathFollow2D.offset += delta * speed
	$PathFollow2D.rotation -= delta * rotation_rate
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#    pass
