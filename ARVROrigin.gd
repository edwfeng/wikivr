extends ARVROrigin

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	print("Hello!")
	
	var VR = ARVRServer.find_interface("OpenVR")
	print(ARVRServer.find_interface("Oculus"))
	if VR and VR.initialize():
		get_viewport().arvr = true
		get_viewport().hdr = false
		
		OS.vsync_enabled = false
		Engine.target_fps = 90
	else:
		print("It break")

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
