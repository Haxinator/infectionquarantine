extends Node2D

var sound_effect_dict = {}

@export var sound_effects: Array[SoundEffect]

func _ready() -> void:
	for sound_effect: SoundEffect in sound_effects:
		sound_effect_dict[sound_effect.type] = sound_effect

func create_audio(type: SoundEffect.SOUND_EFFECT_TYPE) -> void:
	if sound_effect_dict.has(type):
		var sound_effect: SoundEffect = sound_effect_dict[type]
		if sound_effect.has_open_limit():
			sound_effect.change_audio_count(1)
			var new_2d_audio: AudioStreamPlayer2D = AudioStreamPlayer2D.new()
			add_child(new_2d_audio)
			new_2d_audio.stream = sound_effect.sound_effect
			new_2d_audio.volume_db = sound_effect.volume
			new_2d_audio.pitch_scale = sound_effect.pitch_scale
			new_2d_audio.pitch_scale += randf_range(-sound_effect.pitch_randomness, sound_effect.pitch_randomness)
			new_2d_audio.finished.connect(sound_effect.on_audio_finished)
			new_2d_audio.finished.connect(new_2d_audio.queue_free)
			new_2d_audio.play()
	else:
		push_error("Audio Manager failed to find setting for type ", type)

func stop_audio(type: SoundEffect.SOUND_EFFECT_TYPE) -> void:
	if sound_effect_dict.has(type):
		var sound_effect: SoundEffect = sound_effect_dict[type]
		sound_effect.is_queued_for_deletion()
