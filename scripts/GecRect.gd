extends TextureRect

var gec_pic = preload("res://images/Gecko_by_Merlin2525.svg")

const GEC_SIZE = Vector2(54, 81)

onready var image_ = Image.new()

func _ready():
	gec_pic.resize(GEC_SIZE.x, GEC_SIZE.y, Image.INTERPOLATE_TRILINEAR)
	image_.create(get_viewport().get_size().x, get_viewport().get_size().y, false, Image.FORMAT_RGBA8)
	image_.fill(Color(0, 0, 0, 0))
	colored_img.create(GEC_SIZE.x, GEC_SIZE.y, false, Image.FORMAT_RGBA8)
	colored_gec.create(GEC_SIZE.x, GEC_SIZE.y, false, Image.FORMAT_RGBA8)
	colored_gec.fill(Color(0, 0, 0, 0))
	texture = ImageTexture.new()

func _generate_random_position() -> Vector2:
	return Vector2(randf() * (image_.get_size().x - GEC_SIZE.x + 20), randf() * (image_.get_size().y - GEC_SIZE.y + 20))

onready var colored_img = Image.new()
onready var colored_gec = Image.new()
func add_gec():
	colored_img.fill(Color(randf(), randf(), randf(), 0.8))
	colored_gec.blit_rect_mask(colored_img, gec_pic, Rect2(Vector2(), GEC_SIZE), Vector2())
	image_.blend_rect_mask(colored_gec, gec_pic, Rect2(0, 0, 100, 100), _generate_random_position())
	texture.create_from_image(image_)

func reset():
	image_.fill(Color(0, 0, 0, 0))
