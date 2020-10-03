extends KinematicBody2D

var velocity = Vector2(0,0)
var snap = Vector2(0, 0)

export(int) var gravity = 2000
export(int) var speed = 300

func _ready():
	velocity = Vector2(0, 0)

func _physics_process(delta):
	velocity.x = speed
	velocity.y += gravity * delta
	snap = transform.y * 128
	velocity = move_and_slide_with_snap(velocity.rotated(rotation), snap, -transform.y, true, 4, PI/3)
	velocity = velocity.rotated(-rotation)

	if is_on_floor():
		check_animation("walk")
		rotation = get_floor_normal().angle() + PI/2

func check_animation(name):
	if not name == $AnimationPlayer.current_animation:
		$AnimationPlayer.play(name)

