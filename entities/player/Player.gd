extends KinematicBody2D

var keys = Array()
var velocity = Vector2(0,0)
var snap = Vector2(0, 0)

export(int) var gravity = 2000
export(int) var speed = 300
export(int) var jump_speed = -750

var is_jumping = false

func _ready():
	velocity = Vector2(0, 0)

func _physics_process(delta):
	velocity.x = speed
	velocity.y += gravity * delta
	snap = transform.y * 128 if !is_jumping else Vector2.ZERO
	velocity = move_and_slide_with_snap(velocity.rotated(rotation), snap, -transform.y, true, 4, PI/3)
	velocity = velocity.rotated(-rotation)

	if is_on_floor():
		check_animation("walk")
		rotation = get_floor_normal().angle() + PI/2
		is_jumping = false
		if Input.is_action_just_pressed("jump"):
			is_jumping = true
			velocity.y = jump_speed
	else:
		check_animation("jump")
		if is_on_wall():
			rotation = rotation - PI/2

func check_animation(name):
	if not name == $AnimationPlayer.current_animation:
		$AnimationPlayer.play(name)

func manage_on_key(area):
	var key_type = area.get("type")
	keys.append(key_type)
	print("Key type: " + key_type)
	area.hide()
	area.queue_free()

func manage_on_door(area):
	var door_type = area.get("type")
	if keys.has(door_type):
		print("Door: Level pass")
		# TODO, CHANGE STATUS DOOR WITH KEY AND NEXT LEVEL BUTTON
	else:
		print("Door: No Key")

func manage_death():
	pass

func _on_Area2D_area_entered(area):
	if (area.is_in_group("keys")):
		manage_on_key(area)
	if (area.is_in_group("enemies")):
		print("ENEMY AREA")
	if (area.is_in_group("spikes")):
		print("ENEMY AREA")
	if (area.is_in_group("doors")):
		manage_on_door(area)

