extends MeshInstance

const TEXTURES = [
	preload("res://images/100gecs.jpg"),
	preload("res://images/1000gecs.jpg"),
	preload("res://images/1000gecs+toc.jpg"),
]

var current_texture_ := 0

func _set_texture(n):
	get_active_material(0).set_texture(SpatialMaterial.TEXTURE_ALBEDO, TEXTURES[n % TEXTURES.size()])

func change_texture():
	current_texture_ += 1
	_set_texture(current_texture_)

func reset_texture():
	current_texture_ = 0
	_set_texture(current_texture_)
