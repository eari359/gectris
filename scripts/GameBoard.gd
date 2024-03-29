extends Spatial

var TetrisShape = preload("res://scripts/TetrisShape.gd")
var Animator = preload("res://scripts/Animator.gd")
var InputHandler = preload("res://scripts/InputHandler.gd")

onready var GecRect = $"../Camera/CanvasLayer/GecRect"
onready var GecSound = $"../audio/gec"

onready var SwipeHandler = $"../SwipeHandler"
onready var GecControl = $"../GecControl"
onready var Floor = $"../Floor"

const FIELD_WIDTH = 10
const FIELD_HEIGHT = 22

const NEXT_SHAPE_QUEUE_SIZE = 4

var game_field_
var moving_shape_
var next_shape_queue_ := []
var animator_
var input_handler_
var line_counts_
var score_ : int
var time_
var step_time_

func _next_moving_shape():
	moving_shape_.assign(next_shape_queue_[0])
	for i in range(NEXT_SHAPE_QUEUE_SIZE - 1):
		next_shape_queue_[i].assign_animated(next_shape_queue_[i+1])
	animator_.stopAnimation(moving_shape_)
	next_shape_queue_.back().createRandomShape()
	moving_shape_.initPos()
	moving_shape_.createPhantom()

func _prepare_next_shape_queue():
	for i in range(4):
		next_shape_queue_.push_back(TetrisShape.new(game_field_, animator_))
		next_shape_queue_.back().createRandomShape()
		next_shape_queue_.back().translate(Vector3(4, 0, 0))
		next_shape_queue_.back().rotate_y(-PI/6)
		add_child(next_shape_queue_.back())
		for shape in next_shape_queue_:
			shape.translate(Vector3(0, 1.5, 0))

func _prepareShapes():
	moving_shape_ = TetrisShape.new(game_field_, animator_)
	_prepare_next_shape_queue()
	add_child(moving_shape_)

func gameOver():
	print("GAME OVER")
	moving_shape_.queue_free()
	for shape in next_shape_queue_:
		shape.queue_free()
	next_shape_queue_.clear()
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
	_prepareShapes()
	input_handler_ = InputHandler.new(moving_shape_, animator_)
	Floor.reset_texture()
	GecRect.reset()

func _ready():
	initAll()
	SwipeHandler.connect("swipe", self, "swiped")

func swiped(var dir):
	if dir == 1: # right
		moving_shape_.tryMoveRight()
	elif dir == 0: # left
		moving_shape_.tryMoveLeft()
	elif dir == 3: # up
		moving_shape_.tryRotate()
	elif dir == 2: # down
		moving_shape_.instaFall()

func removeLine(var to):
	GecSound.play()
	for i in range(FIELD_WIDTH):
		animator_.destroy(game_field_[i][to])
	for i in range(to-1, -1, -1):
		for j in range(FIELD_WIDTH):
			game_field_[j][i+1] = game_field_[j][i]
			var cube = game_field_[j][i+1]
			if cube != null:
				animator_.translate(cube, Vector3(0, -2, 0))
	moving_shape_.updatePhantom()

func checkFullLines():
	for i in range (FIELD_HEIGHT-1, -1, -1):
		if (line_counts_[i] == FIELD_WIDTH):
			removeLine(i)
			i += 1
			for j in range(i-1, 0, -1):
				line_counts_[j] = line_counts_[j-1]
			add_score()

func add_score():
	score_ += 1
	GecControl.update_gecs(score_)
	GecRect.add_gec()
	step_time_ *= 0.99


func makeStep():
	checkFullLines()
	moving_shape_.fallOne()

func _process(delta):
	if time_ > step_time_:
		time_ -= step_time_
		makeStep()
	time_ += delta
	input_handler_.update(delta)
	animator_.update(delta)
	moving_shape_.update()
	if !moving_shape_.shape_cubes_ or moving_shape_.shape_cubes_.get_children().empty():
		_next_moving_shape()
		if !moving_shape_.canMove(0, 0):
			gameOver()
	if OS.is_debug_build() && Input.is_key_pressed(KEY_SPACE):
		add_score()
