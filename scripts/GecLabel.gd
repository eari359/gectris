extends Label

onready var Floor = $"../Floor"





const GEC_LABEL_TABLE = [
	["zero gec :("],
	["uno gecko"],
	["Gec 2 Ü"],
	["GecGecGec"],
	["Sympathy 4 the Grinch", preload("res://images/sympathy4grinch.jpg")],
	["5 gecs"],
	["6 gecs"],
	["7 gecs"],
	["8 gecs"],
	["9 gecs"],
	["10 gecs"],
	["25 bands and a geccco"],
	["30 gecs"],
	["42 gecs"],
	["50 gecs"],
	["60 gecs"],
	["69 gecs"],
	["70 gecs"],
	["8485 gecs"],
	["90 gecs"],
	["100 gecs", preload("res://images/100gecs.jpg")],
	["200 gecs"],
	["359 gecs"],
	["420 gecs"],
	["500 gecs"],
	["690 gecs"],
	["745 Sticky"],
	["800db cloud"],
	["888db Cloud (Black Dresses Cover)"],
	["909 Worldwide"],
	["1000 gec", preload("res://images/1000gecs.jpg")],
	["2000 gecs"],
	["3000 gecs"],
	["4000 gecs"],
	["5000 gecs"],
	["6000 gecs"],
	["7000 gecs", preload("res://images/1000gecs+toc.jpg")],
	["8000 gecs"],
	["9000 gecs"],
	["10000 gecs", preload("res://images/10000gecs.jpg")],
]

func _score2gecs(score: int):
	var ones = score % 10
	var tens = score / 10
	var gecs = String(ones + 1)
	for i in range(tens):
		gecs += "0"
	return gecs
	
func update_gecs(score: int):
	if score < GEC_LABEL_TABLE.size():
		set_text(GEC_LABEL_TABLE[score][0])
		if GEC_LABEL_TABLE[score].size() > 1 && GEC_LABEL_TABLE[score][1]:
			Floor.set_texture(GEC_LABEL_TABLE[score][1])
	else:
		set_text(_score2gecs(score) + " gecs (" + String(score) + ")")
