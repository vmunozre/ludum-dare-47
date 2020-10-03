extends Node

export (PackedScene) var LevelTutorial
export (PackedScene) var Player

# Called when the node enters the scene tree for the first time.
func _ready():
    var level_tutorial = LevelTutorial.instance()
    level_tutorial.position = $LevelStartPosition.position
    add_child(level_tutorial)
    
    var player = Player.instance()
    player.position = level_tutorial.get_node('PlayerStartPosition').global_position
    add_child(player)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#    pass
