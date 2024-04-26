extends Control
@onready var password = $password
var change_scene=false

func _ready():
	$AnimationPlayer.play("boot")
	if FileAccess.file_exists("user://password.txt"):
		$TextureButton.visible=true

func _on_button_pressed():
	
	if password.text=="":
		password.placeholder_text="Null password"
	else:
		var file = FileAccess.open("user://password.txt", FileAccess.WRITE)
		file.store_string(password.text)
		file.close()
		change_scene=true
	if change_scene:
		get_tree().change_scene_to_file("res://scenes/startpage.tscn")


func _on_texture_button_pressed():
	get_tree().change_scene_to_file("res://scenes/passwordGenerator.tscn")
