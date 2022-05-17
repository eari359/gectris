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

const COLOR = [
	Color(0, 0, 1),
	Color(0, 1, 0),
	Color(0, 1, 1),
	Color(1, 0, 0),
	Color(1, 0, 1),
	Color(1, 1, 0),
	Color(1, 1, 1)
]

const CUBE_SIDE = 0.3

static func getCubeSide():
	return CUBE_SIDE


var shift_from_left_ = 0
var fallen_distance_ = 0
var board_height_
var board_width_
var type_
var rotation_
var being_destroyed_ = false

var board_
var animator_

func getType():
	return type_
func setType(var type):
	type_ = type
func getRotation():
	return rotation_
func setRotation(var rot):
	rotation_ = rot
func setFall(var f):
	fallen_distance_ = f
func getFall():
	return fallen_distance_
func setShift(var s):
	shift_from_left_ = s
func getShift():
	return shift_from_left_
func shift(var d):
	shift_from_left_ += d
func initPos():
	self.translation = ORIGINAL_POSITION + Vector3(shift_from_left_*CUBE_SIDE, -fallen_distance_*CUBE_SIDE, 0)

func _init(var board, var animator):
	myInit(board, animator)

func myInit(var board, var animator):
	animator_ = animator
	board_ = board
	board_width_ = board.size()
	board_height_ = board[0].size()

func createCubeMesh(var x, var y, var c):
	var newInstance = MeshInstance.new()
	newInstance.mesh = CubeMesh.new()
	var mat = SpatialMaterial.new()
	#mat.albedo_color = COLOR[c]
	mat.albedo_color = c
	newInstance.mesh.surface_set_material(0, mat)
	newInstance.translation = Vector3(x*CUBE_SIDE, -y*CUBE_SIDE, 0)
	newInstance.scale = Vector3(CUBE_SIDE/2, CUBE_SIDE/2, CUBE_SIDE/2)
	return newInstance

func update():
	if being_destroyed_:
		if !animator_.isAnimated(self):
			for i in range(4):
				var fieldx = SHAPE[type_][rotation_][2][i][0]+shift_from_left_;
				var fieldy = SHAPE[type_][rotation_][2][i][1]+fallen_distance_;
				var child = self.get_children().back()
				board_[fieldx][fieldy] = child;
				self.remove_child(child)
				self.get_parent().add_child(child)
				self.get_parent().line_counts_[fieldy] += 1
				animator_.stopAnimation(child)
				child.translation = ORIGINAL_POSITION + Vector3(fieldx*CUBE_SIDE, -fieldy*CUBE_SIDE, 0)
			being_destroyed_ = false

func createRandomShape():
	type_ = randi()%7
	rotation_ = randi()%4
	#var col = randi()%7
	var col = Color(randf(), randf(), randf())
	add_child(createCubeMesh(SHAPE[type_][rotation_][2][0][0], SHAPE[type_][rotation_][2][0][1], col))
	add_child(createCubeMesh(SHAPE[type_][rotation_][2][1][0], SHAPE[type_][rotation_][2][1][1], col))
	add_child(createCubeMesh(SHAPE[type_][rotation_][2][2][0], SHAPE[type_][rotation_][2][2][1], col))
	add_child(createCubeMesh(SHAPE[type_][rotation_][2][3][0], SHAPE[type_][rotation_][2][3][1], col))
	shift_from_left_ = SHAPE[type_][rotation_][0]
	fallen_distance_ = SHAPE[type_][rotation_][1]

func canMove(var dx, var dy):
	if self.get_children().empty():
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

const ORIGINAL_POSITION = Vector3(-5*CUBE_SIDE, 2, 0)
func fallOne():
	if self.get_children().empty():
		return 0
	
	if (canMove(0, 1)):
		fallen_distance_ += 1;
		animator_.translate(self, Vector3(0, -CUBE_SIDE, 0))
	else:
		being_destroyed_ = true

func tryRotate():
	if self.get_children().empty():
		return
	
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
	if not stop:
		rotation_ = (rotation_+1)%4
		var i = -1
		for child in self.get_children():
			i += 1
			animator_.setTranslation(child, Vector3(
				CUBE_SIDE*SHAPE[type_][rotation_][2][i][0],
				-CUBE_SIDE*SHAPE[type_][rotation_][2][i][1], 0), 17.5)
			#child.translation = Vector3(
			#	CUBE_SIDE*SHAPE[type_][rotation_][2][i][0],
			#	-CUBE_SIDE*SHAPE[type_][rotation_][2][i][1], 0)

