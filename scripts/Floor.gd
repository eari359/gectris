extends MeshInstance

func set_texture(texture):
	get_active_material(0).set_texture(SpatialMaterial.TEXTURE_ALBEDO, texture)

func reset_texture():
	set_texture(preload("res://images/gecs.jpg"))
