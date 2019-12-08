extends Spatial

var query_thread
var links

func _query(input):
	if input.length() != 0:
		var url = str("https://en.wikipedia.org/wiki/" + input)
		print(url)
		var res = get_viewport().size.x
		print(res)
		var output = []
		OS.execute("node", ["wikipage.js", url, res], true, output)
		
		print(output)
		print(2)
		
		var im = Image.new()
		im.load("output.png")
		print("a")
		var texture = ImageTexture.new()
		print("b")
		texture.create_from_image(im)
		print("c")
		get_node("Viewport/Node2D").get_node("Sprite").texture = texture
		print(3)
		
		var file = File.new()
		
		print(4)
		file.open("output.json", File.READ)
		
		print(5)
		links = JSON.parse(file.get_line()).result
		
		print(links)
		
		refresh_orbs()
		

func refresh_orbs():
	pass

func load_page(name):
	#self._query(null)
	query_thread = Thread.new()
	query_thread.start(self, "_query", name)
	#query_thread.wait_to_finish()

# Called when the node enters the scene tree for the first time.
func _ready():
	var VR = ARVRServer.find_interface("Oculus")
	if VR and VR.initialize():
		get_viewport().arvr = true
		get_viewport().hdr = false
		
		OS.vsync_enabled = false
		Engine.target_fps = 90
        # Also, the physics FPS in the project settings is also 90 FPS. This makes the physics
        # run at the same frame rate as the display, which makes things look smoother in VR!
	
	var viewport = get_node("Viewport")
	viewport.set_clear_mode(Viewport.CLEAR_MODE_ONLY_NEXT_FRAME)
	
	yield(get_tree(), "idle_frame")
	yield(get_tree(), "idle_frame")

	var plane = get_node("Plane")
	(plane.get_surface_material(0)).albedo_texture = viewport.get_texture()
	
	load_page("United_States_of_America")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass