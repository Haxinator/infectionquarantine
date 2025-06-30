extends Resource
# Sound effect resource, used to configure unique sound effects for use with the AudioManager. Passed to [method AudioManager.create_2d_audio_at_location()] and [method AudioManager.create_audio()] to play sound effects.

class_name SoundEffect

# Stores the different types of sounds effects available to be played to distinguish them from another. Each new SoundEffect resource created should add to this enum, to allow them to be easily instantiated via [method AudioManager.create_2d_audio_at_location()] and [method AudioManager.create_audio()].
enum SOUND_EFFECT_TYPE{
	FOLDER_OPEN,
	FOLDER_CLOSE,
	MAIN_BGM,
}

@export_range(0, 10) var limit: int = 5
@export var type: SOUND_EFFECT_TYPE
@export var sound_effect: AudioStreamMP3
@export_range(-40, 20) var volume: float = 0
@export_range(0.0, 4.0, .01) var pitch_scale: float = 1.0
@export_range(0.0, 1.0, .01) var pitch_randomness: float = 0.0

var audio_count = 0 # The instances of this [AudioStreamMP3] currently playing.

# Takes [param amount] to change the [member audio_count]. 
func change_audio_count(amount: int):
	audio_count = max(0, audio_count + amount)

# Checkes whether the audio limit is reached. Returns true if the [member audio_count] is less than the [member limit].
func has_open_limit() -> bool:
	return audio_count < limit

# Connected to the [member sound_effect]'s finished signal to decrement the [member audio_count].
func on_audio_finished() -> void:
	change_audio_count(-1)
