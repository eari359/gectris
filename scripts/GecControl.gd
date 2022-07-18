extends Label

onready var Floor = $"../Floor"
onready var BoofSound = $"../audio/boof"
onready var ScreenShader = $"../Camera/CanvasLayer/ShaderRect"



const GEC_LABEL_TABLE = [
	["zero gec :("],
	["uno gecko"],
	["Gec 2 Ü", null, preload("res://audio/gec2u.wav")],
	["GecGecGec", null, preload("res://audio/gecgecgec.wav")],
	["Sympathy 4 the Grinch", preload("res://images/sympathy4grinch.jpg"), preload("res://audio/4thegrinch.wav")],
	["5 gecs"],
	["6 gecs"],
	["7 gecs"],
	["8 gecs"],
	["9 gecs"],
	["10 gecs"],
	["25 bands and a geccco", null, preload("res://audio/25bands.wav")],
	["30 gecs"],
	["42 gecs"],
	["50 gecs"],
	["60 gecs"],
	["69 gecs"],
	["70 gecs"],
	["80 gecs"],
	["90 gecs"],
	["100 gecs", preload("res://images/100gecs.jpg"), preload("res://audio/bloodstains.wav")],
	["200 gecs"],
	["359 gecs"],
	["420 gecs"],
	["500 gecs"],
	["690 gecs"],
	["745 Sticky"],
	["800db cloud", null, preload("res://audio/800db.wav")],
	["888db Cloud (Black Dresses Cover)", null, preload("res://audio/888db.wav")],
	["909 Worldwide", null, preload("res://audio/909.wav")],
	["1000 gec", preload("res://images/1000gecs.jpg"), preload("res://audio/money_machine.wav")],
	["2000 gecs"],
	["3000 gecs"],
	["4000 gecs"],
	["5000 gecs"],
	["6000 gecs", preload("res://images/1000gecs+toc.jpg"), preload("res://audio/toothless.wav")],
	["7000 gecs"],
	["8485 gecs", null, preload("res://audio/8485.wav")],
	["9000 gecs"],
	["10000 gecs", preload("res://images/10000gecs.jpg"), preload("res://audio/mememe.wav")],
	["20000 gecs"],
	["30000 gecs"],
	["40000 gecs", preload("res://images/doritos_fritos.jpg"), preload("res://audio/doritos_fritos.wav")],
]

func _score2gecs(score: int):
	var ones = score % 10
	var tens = score / 10
	var gecs = String(ones + 1)
	for i in range(tens):
		gecs += "0"
	return gecs

onready var audio_player_ = AudioStreamPlayer.new()
func update_gecs(score: int):
	if score < GEC_LABEL_TABLE.size():
		set_text(GEC_LABEL_TABLE[score][0])
		if GEC_LABEL_TABLE[score].size() > 1 && GEC_LABEL_TABLE[score][1]:
			Floor.set_texture(GEC_LABEL_TABLE[score][1])
		if GEC_LABEL_TABLE[score].size() > 2 && GEC_LABEL_TABLE[score][2]:
			audio_player_.set_stream(GEC_LABEL_TABLE[score][2])
			audio_player_.play()
			return
	else:
		set_text(_score2gecs(score) + " gecs (" + String(score) + ")")

	if (score + 7) % 10 == 0:
		execute_trip()

func _ready():
	add_child(audio_player_)

func execute_trip():
	BoofSound.play()
	ScreenShader.execute_trip()
