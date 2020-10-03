extends KinematicBody2D


var velocity = Vector2(0,0)
var up = Vector2(0, -1) #Current "up" of the player (useful when staying in the ceiling or walls)
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
	velocity = move_and_slide_with_snap(velocity.rotated(rotation),
					snap, -transform.y, true, 4, PI/3)
	velocity = velocity.rotated(-rotation)

	if is_on_floor():
		rotation = get_floor_normal().angle() + PI/2
		is_jumping = false
		if Input.is_action_just_pressed("jump"):
			is_jumping = true
			velocity.y = jump_speed

func _2physics_process(delta):
	velocity.x = speed
	velocity += gravity * delta * (-up)
	#snap = transform.y * 128 if !is_jumping else Vector2.ZERO
	snap = transform.y * 128
	velocity = move_and_slide_with_snap(velocity.rotated(rotation),
					snap, up, true, 4, PI/2)
	velocity = velocity.rotated(-rotation)

	#get_slide_collision(i) usarlo para checkear cuando haya cambios en la colision (wall)
	#la normal de la colision con la wall sera el nuevo up
	#velocity x e y tienen que ser updateados diferent ahora


	if is_on_floor():
		rotation = get_floor_normal().angle() + PI/2
