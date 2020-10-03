extends KinematicBody2D


var velocity = Vector2(0,0)
var up = Vector2(0, -1) #Current "up" of the player (useful when staying in the ceiling or walls)
export var gravity = 100
var snap = Vector2(0, 0)
export var speed = 300

func _ready():
    velocity = Vector2(1000, 0)


func _physics_process(delta):
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
