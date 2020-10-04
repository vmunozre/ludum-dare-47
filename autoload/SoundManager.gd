extends Node

var num_players = 4
var bus = "master"

var jump_sound = "res://assets/sounds/jump.ogg"
var key_sound = "res://assets/sounds/key.ogg"
var win_sound = "res://assets/sounds/win.ogg"
var lose_sound = "res://assets/sounds/lose.ogg"
var music_sound = "res://assets/sounds/music.ogg"
var available = []
var queue = []

func _ready():
	for i in num_players:
		var p = AudioStreamPlayer.new()
		add_child(p)
		available.append(p)
		p.connect("finished", self, "_on_stream_finished", [p])
		p.bus = bus
	# play(music_sound)
func _on_stream_finished(stream):
	available.append(stream)

func play(sound_path):
	queue.append(sound_path)

func _process(delta):
	if not queue.empty() and not available.empty():
		available[0].stream = load(queue.pop_front())
		available[0].play()
		available.pop_front()
