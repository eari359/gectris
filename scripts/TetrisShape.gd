extends Spatial

const shapeSquare = [4, 0,[[0, 0], [0, 1], [1, 0], [1, 1]]];
const shapeLong1 = [ 4, 0, [[-1, 0], [0, 0], [1, 0], [2, 0]] ];
const shapeLong2 = [ 4, 1, [[1, -1], [1, 0], [1, 1], [1, 2]] ];
const shapeL1 = [ 4, 1, [[0, -1], [0, 0], [0, 1], [1, 1]] ];
const shapeL2 = [ 4, 0, [[-1, 1], [0, 1], [1, 1], [1, 0]] ];
const shapeL3 = [ 4, 1, [[0, -1], [1, -1], [1, 0], [1, 1]] ];
const shapeL4 = [ 4, 0, [[-1, 1], [-1, 0], [0, 0], [1, 0]] ];
const shapeRL1 = [ 4, 1, [[1, -1], [1, 0], [1, 1], [0, 1]] ];
const shapeRL2 = [ 4, 0, [[-1, 0], [0, 0], [1, 1], [1, 0]] ];
const shapeRL3 = [ 4, 1, [[0, -1], [1, -1], [0, 0], [0, 1]] ];
const shapeRL4 = [ 4, 0, [[-1, 1], [-1, 0], [0, 1], [1, 1]] ];
const shapeS1 = [ 4, 1, [[0, 0], [0, 1], [1, -1], [1, 0]] ];
const shapeS2 = [ 4, 0, [[-1, 0], [0, 0], [0, 1], [1, 1]] ];
const shapeRS1 = [ 4, 1, [[0, -1], [0, 0], [1, 0], [1, 1]] ];
const shapeRS2 = [ 5, 0, [[0, 0], [1, 0], [0, 1], [-1, 1]] ];
const shapeT1 = [ 4, 0, [[0, 0], [-1, 0], [1, 0], [0, 1]] ];
const shapeT2 = [ 4, 1, [[0, -1], [0, 0], [0, 1], [1, 0]] ];
const shapeT3 = [ 4, 0, [[0, 0], [-1, 1], [0, 1], [1, 1]] ];
const shapeT4 = [ 4, 1, [[0, -1], [0, 0], [-1, 0], [0, 1]] ];

const SHAPE = [
[ shapeSquare, shapeSquare, shapeSquare, shapeSquare, ],
[ shapeLong1, shapeLong2, shapeLong1, shapeLong2, ],
[ shapeL1, shapeL2, shapeL3, shapeL4, ],
[ shapeRL1, shapeRL2, shapeRL3, shapeRL4, ],
[ shapeS1, shapeS2, shapeS1, shapeS2, ],
[ shapeRS1, shapeRS2, shapeRS1, shapeRS2, ],
[ shapeT1, shapeT2, shapeT3, shapeT4, ],
];

const CUBE_SIDE = 0.3

var starting_position_ : Vector3

var shift_from_left_ = 0
var fallen_distance_ = 0
var board_height_
var board_width_
var type_
var rotation_
var being_destroyed_ = false
var color_

var shape_cubes_ = Spatial.new()
var phantom_

var board_
var animator_

func _ready():
	add_child(shape_cubes_)

func _shift(var d):
	shift_from_left_ += d

func initPos():
	shape_cubes_.translation = starting_position_ + Vector3(shift_from_left_*CUBE_SIDE, -fallen_distance_*CUBE_SIDE, 0)

func _init(var board, var animator):
	animator_ = animator
	board_ = board
	board_width_ = board.size()
	board_height_ = board[0].size()
	starting_position_ = Vector3(-5*CUBE_SIDE+0.5*CUBE_SIDE, -2.2 + board_height_*CUBE_SIDE, 0)

func _createCubeMesh(var x, var y, var c):
	var newInstance = MeshInstance.new()
	newInstance.mesh = CubeMesh.new()
	var mat = SpatialMaterial.new()
	mat.albedo_color = c
	newInstance.mesh.surface_set_material(0, mat)
	newInstance.translation = Vector3(x*CUBE_SIDE, -y*CUBE_SIDE, 0)
	newInstance.scale = Vector3(CUBE_SIDE/2, CUBE_SIDE/2, CUBE_SIDE/2)
	return newInstance

func destroyPhantom():
	if phantom_:
		phantom_.queue_free()

func assign(other):
	destroyPhantom()
	type_ = other.type_
	rotation_ = other.rotation_
	color_ = other.color_
	fallen_distance_ = other.fallen_distance_
	shift_from_left_ = other.shift_from_left_
	for cube in other.shape_cubes_.get_children():
		other.shape_cubes_.remove_child(cube)
		shape_cubes_.add_child(cube)
	createPhantom()
	updatePhantom()

func update():
	if being_destroyed_:
		if !animator_.isAnimated(shape_cubes_):
			for i in range(4):
				var fieldx = SHAPE[type_][rotation_][2][i][0]+shift_from_left_;
				var fieldy = SHAPE[type_][rotation_][2][i][1]+fallen_distance_;
				var child = shape_cubes_.get_children().front()
				board_[fieldx][fieldy] = child;
				shape_cubes_.remove_child(child)
				self.get_parent().add_child(child)
				self.get_parent().line_counts_[fieldy] += 1
				animator_.stopAnimation(child)
				child.translation = starting_position_ + Vector3(fieldx*CUBE_SIDE, -fieldy*CUBE_SIDE, 0)
			being_destroyed_ = false

func _createPhantomCube(var x, var y, var c):
	var newInstance = MeshInstance.new()
	newInstance.mesh = CubeMesh.new()
	var mat = ShaderMaterial.new()
	mat.set_shader(preload("res://shaders/phantom_shader.tres"))
	newInstance.mesh.surface_set_material(0, mat)
	newInstance.translation = Vector3(x*CUBE_SIDE, -y*CUBE_SIDE, 0)
	newInstance.scale = Vector3(CUBE_SIDE/2.2, CUBE_SIDE/2.2, CUBE_SIDE/2.2)
	return newInstance

func createPhantom():
	phantom_ = Spatial.new()
	add_child(phantom_)
	phantom_.add_child(_createPhantomCube(SHAPE[type_][rotation_][2][0][0], SHAPE[type_][rotation_][2][0][1], color_))
	phantom_.add_child(_createPhantomCube(SHAPE[type_][rotation_][2][1][0], SHAPE[type_][rotation_][2][1][1], color_))
	phantom_.add_child(_createPhantomCube(SHAPE[type_][rotation_][2][2][0], SHAPE[type_][rotation_][2][2][1], color_))
	phantom_.add_child(_createPhantomCube(SHAPE[type_][rotation_][2][3][0], SHAPE[type_][rotation_][2][3][1], color_))

func updatePhantom():
	if phantom_:
		var phantom_offset = 0
		while canMove(0, phantom_offset + 1):
			phantom_offset += 1
		phantom_.translation = starting_position_ + Vector3(shift_from_left_*CUBE_SIDE, -fallen_distance_*CUBE_SIDE, 0)
		phantom_.translate(Vector3(0, -phantom_offset*CUBE_SIDE, 0))
		var i = -1
		for child in phantom_.get_children():
			i += 1
			child.translation =  Vector3(
				CUBE_SIDE*SHAPE[type_][rotation_][2][i][0],
				-CUBE_SIDE*SHAPE[type_][rotation_][2][i][1], 0)

func createRandomShape():
	type_ = randi()%7
	rotation_ = randi()%4
	
	var sat_val = 0.7 + randf()*0.3
	color_ = Color.from_hsv(randf(), sat_val, sat_val)
	shape_cubes_ = Spatial.new()
	add_child(shape_cubes_)
	shape_cubes_.add_child(_createCubeMesh(SHAPE[type_][rotation_][2][0][0], SHAPE[type_][rotation_][2][0][1], color_))
	shape_cubes_.add_child(_createCubeMesh(SHAPE[type_][rotation_][2][1][0], SHAPE[type_][rotation_][2][1][1], color_))
	shape_cubes_.add_child(_createCubeMesh(SHAPE[type_][rotation_][2][2][0], SHAPE[type_][rotation_][2][2][1], color_))
	shape_cubes_.add_child(_createCubeMesh(SHAPE[type_][rotation_][2][3][0], SHAPE[type_][rotation_][2][3][1], color_))
	shift_from_left_ = SHAPE[type_][rotation_][0]
	fallen_distance_ = SHAPE[type_][rotation_][1]

func canMove(var dx, var dy):
	if shape_cubes_.get_children().empty():
		return 0
	var stop
	for cube in SHAPE[type_][rotation_][2]:
		stop = 0
		var fieldx = cube[0]+shift_from_left_+dx;
		var fieldy = cube[1]+fallen_distance_+dy;
		if (fieldy > board_height_-1
		|| fieldx < 0
		|| fieldx > board_width_-1
		|| board_[fieldx][fieldy] != null):
			stop = 1;
			break;
	return not stop

func fallOne(var amt = 10.0) -> bool:
	if shape_cubes_.get_children().empty():
		return false
	
	if canMove(0, 1):
		fallen_distance_ += 1;
		animator_.translate(shape_cubes_, Vector3(0, -CUBE_SIDE, 0), amt)
		return true
	else:
		being_destroyed_ = true
		return false

func instaFall():
	while fallOne(15.0):
		pass

func tryMoveLeft():
	tryMove(-1)
func tryMoveRight():
	tryMove(1)
func tryMove(dir):
	if canMove(dir, 0):
		being_destroyed_ = false
		animator_.translate(shape_cubes_, Vector3(dir*CUBE_SIDE, 0, 0))
		_shift(dir)
		updatePhantom()

func _canRotate():
	var stop
	var new_shape = Array()
	new_shape.resize(4)
	for i in range(4):
		new_shape[i] = Array()
		new_shape[i].resize(2)
		for j in range(2):
			new_shape[i][j] = SHAPE[type_][(rotation_+1)%4][2][i][j]
	for i in range(4):
		stop = 0
		var fieldx = new_shape[i][0]+shift_from_left_;
		var fieldy = new_shape[i][1]+fallen_distance_;
		if (fieldy > board_height_-1
				|| fieldy < 0
				|| fieldx < 0
				|| fieldx > board_width_-1
				|| board_[fieldx][fieldy] != null):
			stop += 1
			break
	return not stop

func tryRotate():
	if shape_cubes_.get_children().empty():
		return
	if _canRotate():
		being_destroyed_ = false
		rotation_ = (rotation_+1)%4
		var i = -1
		for child in shape_cubes_.get_children():
			i += 1
			animator_.setTranslation(child, Vector3(
				CUBE_SIDE*SHAPE[type_][rotation_][2][i][0],
				-CUBE_SIDE*SHAPE[type_][rotation_][2][i][1], 0), 17.5)
		updatePhantom()

