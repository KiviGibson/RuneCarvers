extends AudioStreamPlayer

const MIX_RATE := 2200.0 
const BUFFER_LENGTH := 0.1

var _playback: AudioStreamGeneratorPlayback

@export var skip: bool = false

func _ready() -> void:
	var gen := AudioStreamGenerator.new()
	gen.mix_rate = MIX_RATE
	gen.buffer_length = BUFFER_LENGTH
	stream = gen
	play()
	_playback = get_stream_playback()

func play_blip(freq: float = 400.0, duration: float = 0.05, volume: float = 0.1) -> void:
	if _playback == null:
		return
	var frames := int(duration * MIX_RATE)
	var frames_available := _playback.get_frames_available()
	var to_write : int = min(frames, frames_available)

	for i in to_write:
		if skip: break
		var t := float(i) / MIX_RATE
		var square := 1.0 if sin(TAU * freq * t) >= 0.0 else -1.0
		var fade := 1.0 - (float(i) / to_write)
		var value := square * volume * fade
		_playback.push_frame(Vector2(value, value))
	
	skip = false
