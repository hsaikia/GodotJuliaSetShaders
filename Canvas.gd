extends Sprite	

var w = 32
var h = 32

func set_center():
	var WH = OS.get_real_window_size()
	var mp = get_viewport().get_mouse_position()
	mp.x = clamp(mp.x, 0, WH.x)
	mp.y = clamp(mp.y, 0, WH.y)
	var rel_mp = Vector2(mp.x / WH.x, mp.y / WH.y)
	position = WH/2
	scale = Vector2(WH.x/w, WH.y/h)
	material.set_shader_param("ar", WH.x / WH.y)
	material.set_shader_param("position", rel_mp)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	set_center()
	if Input.is_action_just_released("increase_max_iterations"):
		var i = material.get_shader_param("num_iterations")
		material.set_shader_param("num_iterations", min(1000.0, i + 1))
	if Input.is_action_just_released("decrease_max_iterations"):
		var i = material.get_shader_param("num_iterations")
		material.set_shader_param("num_iterations", max(1.0, i - 1))
	if Input.is_action_just_released("zoom_in"):
		var s = material.get_shader_param("scale")
		material.set_shader_param("scale", s * 1.1)
	if Input.is_action_just_released("zoom_out"):
		var s = material.get_shader_param("scale")
		material.set_shader_param("scale", s / 1.1)
	if Input.is_action_just_released("switch_fractal"):
		var is_julia = material.get_shader_param("julia")
		material.set_shader_param("julia", !is_julia)
