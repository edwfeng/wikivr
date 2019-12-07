extends Node2D

var query_thread

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
		get_node("Sprite").texture = texture
		print(3)
		
		

func load_page(name):
	#self._query(null)
	query_thread = Thread.new()
	query_thread.start(self, "_query", name)
	#query_thread.wait_to_finish()

func _ready():
	load_page("Doge_(meme)")
