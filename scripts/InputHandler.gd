var TetrisShape = preload("res://scripts/TetrisShape.gd")

var moving_shape_
var animator_

var key_counters = {
	KEY_LEFT : [0, -1],
	KEY_RIGHT : [0, 1]
	}

func _init(var moving_shape, var animator):
	moving_shape_ = moving_shape
	animator_ = animator

const COUNTER_THRESHOLD = 1.5
func stepMove(var key, var delta):
	if Input.is_key_pressed(key):
		if key_counters[key][0] == 0 || key_counters[key][0] > COUNTER_THRESHOLD:
			moving_shape_.tryMove(key_counters[key][1])
			key_counters[key][0] -= COUNTER_THRESHOLD
		key_counters[key][0] += delta*20
	else:
		key_counters[key][0] = 0

var was_down = false
var down_counter = 0
var was_up = false
func update(var delta):
	stepMove(KEY_LEFT, delta)
	stepMove(KEY_RIGHT, delta)
	if Input.is_key_pressed(KEY_DOWN):
		if not was_down:
			moving_shape_.fallOne()
		was_down = true
		down_counter += delta
		if down_counter > 0.1:
			down_counter = 0
			moving_shape_.fallOne()
	else:
		was_down = false
	if Input.is_key_pressed(KEY_UP):
		if not was_up:
			moving_shape_.tryRotate()
		was_up = true
	else:
		was_up = false
