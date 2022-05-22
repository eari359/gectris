extends Label







const GEC_LABEL_TABLE = [
	"zero gec :(",
	"uno gecko",
	"Gec 2 Ü",
	"GecGecGec",
	"Sympathy 4 the Grinch",
	"5 gecs",
	"6 gecs",
	"7 gecs",
	"8 gecs",
	"9 gecs",
	"10 gecs",
	"25 bands and a geccco",
	"30 gecs",
	"42 gecs",
	"50 gecs",
	"69 gecs",
	"70 gecs",
	"8485 gecs",
	"90 gecs",
	"100 gecs",
	"111",
	"200 gecs",
	"359 gecs",
	"420 gecs",
	"500 gecs",
	"690 gecs",
	"745 Sticky",
	"800db cloud",
	"888db Cloud (Black Dresses Cover)",
	"909 Worldwide",
	"1000 gec",
]

func update_text(score: int):
	if score < GEC_LABEL_TABLE.size():
		set_text(GEC_LABEL_TABLE[score])
	else:
		set_text(String(score) + " bajillion gecs")
