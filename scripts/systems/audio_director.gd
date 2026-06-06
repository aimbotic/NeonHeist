class_name AudioDirector
extends Node

const SAMPLE_RATE := 22050
const PLAYER_COUNT := 8

var _players: Array[AudioStreamPlayer] = []
var _next_player := 0
var _streams: Dictionary = {}
var _played_counts: Dictionary = {}

func _ready() -> void:
	for i in range(PLAYER_COUNT):
		var player := AudioStreamPlayer.new()
		player.bus = "Master"
		add_child(player)
		_players.append(player)
	_build_streams()

func play_cue(cue: String, strength: float = 1.0) -> void:
	if not _streams.has(cue) or _players.is_empty():
		return
	_played_counts[cue] = int(_played_counts.get(cue, 0)) + 1
	var player := _players[_next_player]
	_next_player = (_next_player + 1) % _players.size()
	player.stop()
	player.stream = _streams[cue]
	player.volume_db = clampf(-8.0 + strength * 3.5, -14.0, -1.0)
	player.pitch_scale = randf_range(0.94, 1.06)
	player.play()

func get_played_count(cue: String) -> int:
	return int(_played_counts.get(cue, 0))

func _build_streams() -> void:
	_streams["gun"] = _make_impact_stream(0.16, 560.0, 72.0, 0.82, 0.62, 0.18)
	_streams["slash"] = _make_sweep_stream(0.18, 920.0, 280.0, 0.5)
	_streams["parry"] = _make_impact_stream(0.22, 1260.0, 360.0, 0.62, 0.18, 0.28)
	_streams["explosion"] = _make_impact_stream(0.42, 150.0, 38.0, 1.0, 0.84, 0.35)
	_streams["hit"] = _make_impact_stream(0.18, 190.0, 54.0, 0.58, 0.7, 0.2)
	_streams["chain"] = _make_impact_stream(0.2, 430.0, 90.0, 0.65, 0.46, 0.2)
	_streams["dry"] = _make_impact_stream(0.1, 760.0, 520.0, 0.34, 0.08, 0.16)
	_streams["reward"] = _make_impact_stream(0.26, 880.0, 1320.0, 0.46, 0.1, 0.5)
	_streams["hunter_lunge"] = _make_sweep_stream(0.2, 260.0, 980.0, 0.46)
	_streams["black_sash_lunge"] = _make_impact_stream(0.24, 360.0, 1040.0, 0.52, 0.28, 0.34)
	_streams["mercy_vale_lunge"] = _make_sweep_stream(0.18, 980.0, 340.0, 0.28)
	_streams["june_blackglass_lunge"] = _make_impact_stream(0.28, 1180.0, 220.0, 0.48, 0.34, 0.3)
	_streams["level_start"] = _make_impact_stream(0.3, 520.0, 880.0, 0.42, 0.18, 0.32)
	_streams["level_clear"] = _make_impact_stream(0.34, 720.0, 1180.0, 0.5, 0.12, 0.42)

func _make_impact_stream(duration: float, start_hz: float, end_hz: float, tone_gain: float, noise_gain: float, decay_power: float) -> AudioStreamWAV:
	var sample_count := int(SAMPLE_RATE * duration)
	var bytes := PackedByteArray()
	bytes.resize(sample_count * 2)
	var write_index := 0
	var phase := 0.0
	var noise_hold := 0.0
	for i in range(sample_count):
		var t := float(i) / float(maxi(1, sample_count - 1))
		var envelope := pow(1.0 - t, decay_power) * minf(1.0, t * 42.0)
		var hz := lerpf(start_hz, end_hz, t)
		phase += TAU * hz / float(SAMPLE_RATE)
		if i % 3 == 0:
			noise_hold = randf_range(-1.0, 1.0)
		var tone := sin(phase) * tone_gain
		var crackle := noise_hold * noise_gain
		var sample := clampf((tone + crackle) * envelope, -1.0, 1.0)
		write_index = _write_i16(bytes, write_index, sample)
	return _wav_from_bytes(bytes)

func _make_sweep_stream(duration: float, start_hz: float, end_hz: float, noise_gain: float) -> AudioStreamWAV:
	var sample_count := int(SAMPLE_RATE * duration)
	var bytes := PackedByteArray()
	bytes.resize(sample_count * 2)
	var write_index := 0
	var phase := 0.0
	for i in range(sample_count):
		var t := float(i) / float(maxi(1, sample_count - 1))
		var attack := minf(1.0, t * 18.0)
		var envelope := attack * pow(1.0 - t, 0.72)
		var hz := lerpf(start_hz, end_hz, t)
		phase += TAU * hz / float(SAMPLE_RATE)
		var tone := sin(phase) * 0.58
		var hiss := randf_range(-1.0, 1.0) * noise_gain
		var sample := clampf((tone + hiss) * envelope, -1.0, 1.0)
		write_index = _write_i16(bytes, write_index, sample)
	return _wav_from_bytes(bytes)

func _write_i16(bytes: PackedByteArray, index: int, sample: float) -> int:
	var value := int(sample * 32767.0)
	if value < 0:
		value += 65536
	bytes[index] = value & 0xff
	bytes[index + 1] = (value >> 8) & 0xff
	return index + 2

func _wav_from_bytes(bytes: PackedByteArray) -> AudioStreamWAV:
	var stream := AudioStreamWAV.new()
	stream.format = AudioStreamWAV.FORMAT_16_BITS
	stream.mix_rate = SAMPLE_RATE
	stream.stereo = false
	stream.data = bytes
	return stream
