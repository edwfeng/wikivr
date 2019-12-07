extends CanvasLayer

var query_thread

func _query(null_arg):
    print(null_arg)
    var input = $TextEdit.get_text().replace(" ", "%20")
    print(input)
    if input.length() != 0:
        var url = str("https://en.wikipedia.org/wiki/" + input)
        print(url)
        var res = get_viewport().x
        print(res)
        var output = []
        OS.execute("node", ["wikipage.js", url, res], true, output)
        
        
        print(output)
        print(2)
        
        # $Sprite.texture = load("output.png")
        var im = Image.new()
        im.load("output.png")
        # im.resize(res, im.get_height() * (res/im.get_width()))
        print("a")
        var texture = ImageTexture.new()
        print("b")
        texture.create_from_image(im)
        print("c")
        $Sprite.texture = texture
        print(3)

func _on_Button_pressed():
    if $TextEdit.get_text().length() != 0:
        query_thread = Thread.new()
        query_thread.start(self, "_query")
        #query_thread.wait_to_finish()
