extends Control

var LoginPassword = ""
@onready var password = $password
var tries=0
func _ready():
	
	if !FileAccess.file_exists("user://save.txt"):
		var file = FileAccess.open("user://save.txt", FileAccess.WRITE)
		file.close()
	if !FileAccess.file_exists("user://password.txt"):
		get_tree().change_scene_to_file("res://appPassword.tscn")
	else:
		var file = FileAccess.open("user://password.txt",FileAccess.READ)
		LoginPassword = file.get_as_text()
		file.close()
	


func _on_enter_pressed():
	if (password.text == LoginPassword):
		get_tree().change_scene_to_file("res://scenes/passwordGenerator.tscn")
		
	else:
		password.text=""
		password.placeholder_text="incorrect password"
		tries+=1
	if tries==7:
		get_tree().quit()
