extends Spatial

var TetrisShape = preload("res://TetrisShape.gd")
var Animator = preload("res://Animator.gd")
var InputHandler = preload("res://InputHandler.gd")

const FIELD_WIDTH = 10
const FIELD_HEIGHT = 14

var game_field_
var moving_shape_
var next_shape_
var animator_
var input_handler_
var line_counts_
var score_
var time_
var step_time_

func prepareShapes():
	#moving_shape_ = 
	moving_shape_ = TetrisShape.new(game_field_, animator_)
	#moving_shape_.add_child()
	next_shape_ = TetrisShape.new(game_field_, animator_)
	next_shape_.createRandomShape();
	next_shape_.translate(Vector3(4, 0, 0))
	next_shape_.rotate_y(-PI/3)
	add_child(next_shape_)
	add_child(moving_shape_)

func gameOver():
	moving_shape_.queue_free()
	next_shape_.queue_free()
	for c in self.get_children():
		c.queue_free()
	initAll()

func initVars():
	game_field_ = Array()
	animator_ = Animator.new()
	for i in range(FIELD_WIDTH):
		game_field_.append(Array())
		game_field_[i].resize(FIELD_HEIGHT)
		for j in range(FIELD_HEIGHT):
			game_field_[i][j] = null
	time_ = 0
	score_ = 0
	step_time_ = 0.8
	line_counts_ = Array()
	line_counts_.resize(FIELD_HEIGHT)
	for i in range(FIELD_HEIGHT):
		line_counts_[i] = 0

func initAll():
	randomize()
	initVars()
	prepareShapes()
	input_handler_ = InputHandler.new(moving_shape_, animator_)

func _ready():
	initAll()
	self.get_parent().get_children()[1].connect("swipe", self, "swiped")

func swiped(var dir):
	if dir == 1 && moving_shape_.canMove(1, 0):
		var move_vector = Vector3(1*TetrisShape.getCubeSide(), 0, 0)
		animator_.translate(moving_shape_, move_vector)
		moving_shape_.shift(1)
	elif dir == 0 && moving_shape_.canMove(-1, 0):
		var move_vector = Vector3(-1*TetrisShape.getCubeSide(), 0, 0)
		animator_.translate(moving_shape_, move_vector)
		moving_shape_.shift(-1)
	elif dir == 3:
		moving_shape_.tryRotate()
	elif dir == 2:
		moving_shape_.fallOne()

func removeLine(var to):
	for i in range(FIELD_WIDTH):
		animator_.destroy(game_field_[i][to])
	for i in range(to-1, -1, -1):
		for j in range(FIELD_WIDTH):
			game_field_[j][i+1] = game_field_[j][i]
			var cube = game_field_[j][i+1]
			if cube != null:
				animator_.translate(cube, Vector3(0, -2, 0))

func checkFullLines():
	for i in range (FIELD_HEIGHT-1, -1, -1):
		if (line_counts_[i] == FIELD_WIDTH):
			removeLine(i)
			i += 1
			score_ += 1
			step_time_ *= 0.99
			self.get_parent().get_child(0).text = "Score: " + String(score_)
			for j in range(i-1, 0, -1):
				line_counts_[j] = line_counts_[j-1]
			
#	var full
#	for i in range(FIELD_HEIGHT-1, -1, -1):
#		full = 0
#		for j in range(FIELD_WIDTH):
#			if game_field_[j][i] != null:
#				full += 1
#		if (full == FIELD_WIDTH):
#			removeLine(i)
#			i += 1
#			score += 1
#			step_time_ *= 0.99
#			self.get_child(0).text = "Score: " + String(score)
#			continue

func makeStep():
	moving_shape_.fallOne()
	if moving_shape_.get_children().empty():
		moving_shape_.setType(next_shape_.getType())
		moving_shape_.setRotation(next_shape_.getRotation())
		moving_shape_.setFall(next_shape_.getFall())
		moving_shape_.setShift(next_shape_.getShift())
		animator_.stopAnimation(moving_shape_)
		moving_shape_.initPos()
		for child in next_shape_.get_children():
			next_shape_.remove_child(child)
			moving_shape_.add_child(child)
		next_shape_.createRandomShape()
		if !moving_shape_.canMove(0, 0):
			gameOver()
	checkFullLines()

func _process(delta):
	if time_ > step_time_:
		time_ -= step_time_
		makeStep()
	time_ += delta
	input_handler_.update(delta)
	animator_.update(delta)

