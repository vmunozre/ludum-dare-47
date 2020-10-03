extends KinematicBody2D

var keys = Array()
var velocity = Vector2(0,0)
var snap = Vector2(0, 0)

export(int) var gravity = 2000
export(int) var speed = 300
export(int) var jump_speed = -750

var is_jumping = false

func _ready():
	velocity = Vector2(1000, 0)

func _physics_process(delta):
	velocity.x = speed
	velocity.y += gravity * delta
	snap = transform.y * 128 if !is_jumping else Vector2.ZERO
	velocity = move_and_slide_with_snap(velocity.rotated(rotation), snap, -transform.y, true, 4, PI/3)
	velocity = velocity.rotated(-rotation)

	if is_on_floor():
		rotation = get_floor_normal().angle() + PI/2
		is_jumping = false
		if Input.is_action_just_pressed("jump"):
			is_jumping = true
			velocity.y = jump_speed


func _on_key_taken(value):
	print("Key: " + value)
	keys.append(value)
