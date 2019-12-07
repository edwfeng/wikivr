extends CanvasLayer

func _ready():
    pass

func _on_Button_pressed():
    print(17359)
    var input = $TextEdit.get_text().replace(" ", "%20")
    print(input)
    if input.length() != 0:
        var url = str("https://en.wikipedia.org/wiki/" + input)
        print(url)
        var res = OS.get_screen_size().x
        print(res)
        print(1)
        # print(query)
        OS.execute("node", ["wikipage.js", url, res], true)
        print(2)
        $Sprite.texture = load("res://output.png")
