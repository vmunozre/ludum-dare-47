extends Node

var num_players = 4
var bus = "master"
var is_mute = false
var jump_sound = "res://assets/sounds/jump.ogg"
var key_sound = "res://assets/sounds/key.ogg"
var win_sound = "res://assets/sounds/win.ogg"
var lose_sound = "res://assets/sounds/lose.ogg"
var music_sound = "res://assets/sounds/music.ogg"
var available = []
var queue = []
var playing = []

func _ready():
	for i in num_players:
		var p = AudioStreamPlayer.new()
		add_child(p)
		available.append(p)
		p.connect("finished", self, "_on_stream_finished", [p])
		p.bus = bus
	play(music_sound)
func _on_stream_finished(stream):
	if playing.has(stream):
		var index = playing.find(stream, 0)
		playing.remove(index)
	available.append(stream)

func play(sound_path):
	if not is_mute:
		queue.append(sound_path)

func mute():
	is_mute = not is_mute
	for i in playing:
		i .stream_paused = is_mute
	for i in available:
		i.stream_paused = is_mute

func _process(delta):
	if Input.is_action_just_pressed("mute"):
		mute()
	if not queue.empty() and not available.empty():
		available[0].stream = load(queue.pop_front())
		available[0].play()
		playing.append(available.pop_front())
