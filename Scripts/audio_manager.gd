extends Node

var num_players = 50
var bus = "master"

var available : Array[AudioStreamPlayer]  # The available players.
var queue : Array[AudioStream]  # The queue of sounds to play.


func _ready():
	# Create the pool of AudioStreamPlayer nodes.
	for i in num_players:
		var player = AudioStreamPlayer.new()
		add_child(player)
		available.append(player)
		player.finished.connect(_on_stream_finished.bind(player))
		player.bus = bus

func _on_stream_finished(stream):
	# When finished playing a stream, make the player available again.
	available.append(stream)

func play(sound_stream):
	queue.append(sound_stream)

func _process(_delta):
	# Play a queued sound if any players are available.
	while not queue.is_empty():
		if available.is_empty():
			queue.clear()
		available[0].stream = queue.pop_front()
		available[0].play()
		available.pop_front()
