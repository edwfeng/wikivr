extends Spatial

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	var viewport = get_node("Viewport")
	viewport.set_clear_mode(Viewport.CLEAR_MODE_ONLY_NEXT_FRAME)
	
	yield(get_tree(), "idle_frame")
	yield(get_tree(), "idle_frame")

	var plane = get_node("Plane")
	(plane.get_surface_material(0)).albedo_texture = viewport.get_texture()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass