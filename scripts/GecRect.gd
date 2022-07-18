extends TextureRect

var gec_pic = preload("res://images/Gecko_by_Merlin2525.svg")


#const GEC_PIC_RES = Vector2(658.0, 991.0)
const GEC_SIZE = Vector2(54, 81)

onready var image_ = Image.new()

func _ready():
	image_.create(get_viewport().get_size().x, get_viewport().get_size().y, false, Image.FORMAT_RGBA8)
	image_.fill(Color(0, 0, 0, 0))
#	var gec_scale_num = image_.get_size().x * image_.get_size().y * 8.5e-08
#	GEC_SIZE = gec_scale_num * GEC_PIC_RES
	gec_pic.resize(GEC_SIZE.x, GEC_SIZE.y, Image.INTERPOLATE_TRILINEAR)
	colored_img.create(GEC_SIZE.x, GEC_SIZE.y, false, Image.FORMAT_RGBA8)
	texture = ImageTexture.new()

func _generate_random_position() -> Vector2:
	return Vector2(randf() * (image_.get_size().x - GEC_SIZE.x + 20), randf() * (image_.get_size().y - GEC_SIZE.y + 20))

onready var colored_img = Image.new()
func add_gec():
	colored_img.fill(Color(randf(), randf(), randf(), 0.8))
	image_.blend_rect_mask(colored_img, gec_pic, Rect2(0, 0, 100, 100), _generate_random_position())
	texture.create_from_image(image_)

func reset():
	image_.fill(Color(0, 0, 0, 0))
