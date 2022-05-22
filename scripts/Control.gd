extends Control

signal swipe
var swipe_start = null
var minimum_drag = 100

func _input(event):
	if event.is_action_pressed("click"):
		swipe_start = get_global_mouse_position()
	if event.is_action_released("click"):
		_calculate_swipe(get_global_mouse_position())

func _calculate_swipe(swipe_end):
	if swipe_start == null: 
		return
	var swipe = swipe_end - swipe_start
	print(swipe)
	if abs(swipe.x) > minimum_drag:
		if swipe.x > 0:
			emit_signal("swipe", 1)
		else:
			emit_signal("swipe", 0)
	if abs(swipe.y) > minimum_drag:
		if swipe.y > 0:
			emit_signal("swipe", 2)
		else:
			emit_signal("swipe", 3)
