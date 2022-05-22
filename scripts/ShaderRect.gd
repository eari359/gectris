extends ColorRect

onready var trip_timer_ := Timer.new()

func init_trip_timer():
	add_child(trip_timer_)
	trip_timer_.set_one_shot(true)
	trip_timer_.set_wait_time(15.0)
	trip_timer_.connect("timeout", self, "stop_trip")
	
func _ready():
	init_trip_timer()

func execute_trip():
	material.set_shader_param("trip_level", lerp(20.0, 100.0, randf()))
	material.set_shader_param("trip", true)
	trip_timer_.start()

func stop_trip():
	material.set_shader_param("trip", false)
