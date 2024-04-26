extends Control

@onready var Name =$Name
@onready var GeneratedPass =$GeneratedPass
@onready var Length = $length
@onready var specialCharacterButton=$specialCharacters
@onready var numberOnlyButton = $numbersOnly

var specialCharacter = true
var numberOnly =false
var saveEnable=true
var recentGeneration=""



func _ready():
	Name.grab_focus()
	$AnimationPlayer.play("buttonSlide")
	
	
func _input(event):
	if Input.is_action_just_pressed("click") and $QrShader/QRCodeRect.visible:
		$QrShader.visible=false


func _on_generate_pressed():
	#check is Name is entered or not
	if(Name.text!="" and Length.text!=""):
		Global.Name=Name.text
		var password=""
		var length=int(Length.text)
		if !length:
			Length.text=""
			Length.placeholder_text="Error Length "
		if specialCharacter:
			password=generate_special_character(length)
		else:
			password=generate_password(length)
		GeneratedPass.text=password
		Global.length=length
		Global.generatedPassword=password
		
	else:
		if(Name.text==""):
			Name.placeholder_text="Name:REQUIRED"
		if(Length.text==""):
			Length.placeholder_text="Length:REQUIRED"


func _on_my_passwords_pressed():
	get_tree().change_scene_to_file("res://scenes/savedPasswords.tscn")


func _on_special_characters_pressed():
	specialCharacter=specialCharacterButton.button_pressed
	numberOnlyButton.button_pressed=false
	numberOnly=false


func _on_qrcode_pressed():
	$QrShader/QRCodeRect.data= "Name: "+Name.text+"\n"+"Password: "+GeneratedPass.text
	$QrShader.visible=true

func _on_save_pressed():
	if Name.text !="" and GeneratedPass.text!="":
		if !(recentGeneration==Global.generatedPassword):
			var file = FileAccess.open("user://save.txt", FileAccess.READ_WRITE)
			file.seek_end()
			file.store_string(Name.text)
			file.store_string(","+GeneratedPass.text+"\n")
			file.close()
			recentGeneration=Global.generatedPassword


func _on_numbers_only_pressed():
	numberOnly=numberOnlyButton.button_pressed
	specialCharacterButton.button_pressed=false
	specialCharacter=false


func generate_special_character(length: int) -> String:
	var uppercase_chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
	var lowercase_chars = "abcdefghijklmnopqrstuvwxyz"
	var digit_chars = "0123456789"
	var special_chars ="!@#$%^&*(),.?:{}|<>"
	var all_chars = uppercase_chars + lowercase_chars + digit_chars + special_chars
	
	var password = ""
	 # Ensure at least one character from each category
	password += uppercase_chars[randi() % uppercase_chars.length()]
	password += lowercase_chars[randi() % lowercase_chars.length()]
	password += digit_chars[randi() % digit_chars.length()]
	password += special_chars[randi() % special_chars.length()]
	 # Generate the remaining characters randomly
	for i in range(length - 4):
		password += all_chars[randi() % all_chars.length()]
	# Shuffle the password to make the order random
	return password


# Function to generate a strong password
func generate_password(length: int) -> String:
	var charset = ""
	if numberOnly:
		charset="0123456789" 	
	else:
		charset="ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"
	var password = ""
	for i in range(length):
		var random_index = randi() % charset.length()
		password += charset.substr(random_index, 1)
	return password

func _on_texture_button_pressed():
	get_tree().change_scene_to_file("res://appPassword.tscn")


func _on_password_checker_pressed():
	get_tree().change_scene_to_file("res://scenes/passwordChecker.tscn")
