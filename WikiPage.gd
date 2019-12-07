extends CanvasLayer

func _ready():
    pass

func _on_Button_pressed():
    var input = $TextEdit.get_text().replace(" ", "%20")
    if input.length() != 0:
        var query = str("https://en.wikipedia.org/w/api.php?format=json&action=parse&section=0&page=" + input)
        # print(query)
        $HTTPRequest.request(query)

func _on_HTTPRequest_request_completed(result, response_code, headers, body):
    var json = JSON.parse(body.get_string_from_utf8())
    # print(json.result.parse.text["*"])
    $RichTextLabel.add_text(json.result.parse.text["*"])
