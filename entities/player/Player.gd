extends KinematicBody2D

var keys = Array()
var velocity = Vector2()
var snap = Vector2()

export(int) var gravity = 2000
export(int) var speed = 300
export(int) var jump_speed = -750
export(Vector2) var start_position = Vector2()

var base_speed = 300
var ghost_speed = 200
var is_jumping = false
var is_dying = false
var is_ghost = false

func _ready():
	velocity = Vector2()

func _physics_process(delta):
	if not is_ghost:
		velocity.x = speed
		velocity.y += gravity * delta
		snap = transform.y * 128 if !is_jumping else Vector2.ZERO
		velocity = move_and_slide_with_snap(velocity.rotated(rotation), snap, -transform.y, true, 4, PI/3)
		velocity = velocity.rotated(-rotation)
	else: 
		if position.distance_to(start_position) > 10:
			velocity = start_position - position
		else:
			manage_revive()
		if velocity.length() > 0:
			velocity = velocity.normalized() * ghost_speed
		position += velocity * delta
		
	if not is_dying:
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
	elif is_ghost:
		check_animation("ghost")
	else:
		check_animation("die")

func check_animation(name):
	if not name == $AnimationPlayer.current_animation:
		$AnimationPlayer.play(name)

func manage_revive():
	is_dying = false
	is_ghost = false
	set_collision_layer_bit(0, true)
	set_collision_mask_bit(0, true)
	speed = base_speed
	$Sprite.modulate = Color(1, 1, 1, 1) #set default

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
	is_dying = true
	set_collision_layer_bit(0, false)
	set_collision_mask_bit(0, false)
	speed = 0
	yield($AnimationPlayer,"animation_finished")
	is_ghost = true

func _on_Area2D_area_entered(area):
	if not is_dying:
		if (area.is_in_group("keys")):
			manage_on_key(area)
		if (area.is_in_group("enemies")):
			print("ENEMY AREA")
			manage_death()
		if (area.is_in_group("spikes")):
			print("ENEMY AREA")
		if (area.is_in_group("doors")):
			manage_on_door(area)

