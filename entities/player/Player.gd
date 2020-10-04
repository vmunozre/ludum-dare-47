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

var is_transition_between_levels = false

func _ready():
	velocity = Vector2()

func _physics_process(delta):
	if not is_transition_between_levels: 
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

func _process(delta):
	transition_between_levels(delta)
	
func check_animation(name):
	if not name == $AnimationPlayer.current_animation:
		$AnimationPlayer.play(name)

func manage_revive():
	set_collision_layer_bit(0, true)
	set_collision_mask_bit(0, true)
	speed = base_speed
	rotation = 0
	snap = Vector2()
	velocity = Vector2()
	velocity = move_and_slide(velocity, snap, true)
	$Sprite.modulate = Color(1, 1, 1, 1) #set default
	is_dying = false
	is_ghost = false

func manage_on_key(area):
	var key_type = area.get("type")
	keys.append(key_type)
	print("Key type: " + key_type)
	area.hide()
	area.queue_free()

func manage_on_door(area):
	var door_type = area.get("type")
	if keys.has(door_type):
		print("Door opened")
		var index = keys.find(door_type,0)
		keys.remove(index)
		area.open_door()
	else:
		print("Door: No Key")

func manage_death():
	is_dying = true
	set_collision_layer_bit(0, false)
	set_collision_mask_bit(0, false)
	speed = 0
	yield($AnimationPlayer,"animation_finished")
	rotation = 0
	is_ghost = true

func _on_Area2D_area_entered(area):
	if not is_dying:
		if (area.is_in_group("keys")):
			manage_on_key(area)
		if (area.is_in_group("enemies")):
			print("AREA: Enemy")
			manage_death()
		if (area.is_in_group("spikes")):
			print("AREA: Spikes")
			manage_death()
		if (area.is_in_group("doors")):
			manage_on_door(area)

func reset_player():
	velocity = Vector2(1000, 0)
	rotation = 0
	is_jumping = false

func start_transition_between_levels(final_position, transition_time, max_scale=50, rotation_rate_transition=-4):
	start_position = final_position
	var time_peak = transition_time / 2
	is_transition_between_levels = true
	
	#Disabling collisions for transition
	$CollisionShape2D.set_deferred("disabled", true)
	$Area2D.set_deferred("disabled", true)
	$Area2D/CollisionShape2D.set_deferred("disabled", true)
	
	#Position
	$Tween.interpolate_property(self, "position",
	position, final_position, transition_time,
	Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	
	#Scaling up
	$Tween.interpolate_property(self, "scale",
	null, Vector2(max_scale, max_scale), time_peak,
	Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	
	#Scaling down
	$Tween.interpolate_property(self, "scale",
	Vector2(max_scale, max_scale), Vector2(1, 1), time_peak,
	Tween.TRANS_LINEAR, Tween.EASE_IN_OUT, time_peak)
	
	#Rotation
	$Tween.interpolate_property(self, "rotation",
	null, rotation_rate_transition * PI, transition_time,
	Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	
	$Tween.start()

func transition_between_levels(_delta):
	if !$Tween.is_active():
		is_transition_between_levels = false
		$CollisionShape2D.set_deferred("disabled", false)
		$Area2D.set_deferred("disabled", false)
		$Area2D/CollisionShape2D.set_deferred("disabled", false)
		#rotation = 2 * PI
		#todo activate collisions
