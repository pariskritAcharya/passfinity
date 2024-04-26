extends Control

# Function to categorize the strength of a password


func categorize_password_strength(password: String) -> String:
	# Check minimum length
	if password.length() < 8:
		return "Weak"

	var has_uppercase = false
	var has_lowercase = false
	var has_digit = false
	var has_special_char = false

	# Check for uppercase, lowercase, digit, and special character
	for char in password:
		if 'A' <= char and char <= 'Z':
			has_uppercase = true
		elif 'a' <= char and char <= 'z':
			has_lowercase = true
		elif '0' <= char and char <= '9':
			has_digit = true
		elif char in "!@#$%^&*(),.?:{}|<>":
			has_special_char = true

	# Categorize based on criteria
	if has_uppercase and has_lowercase and has_digit and has_special_char:
		return "Strong"
	elif has_uppercase or has_lowercase or has_digit or has_special_char:
		return "Medium"
	else:
		return "Weak"

# Example usage
func _ready():
	pass



func _on_enter_pressed():
	var password_to_check = $password.text
	var strength_category = categorize_password_strength(password_to_check)
	if strength_category=="Strong":
		$StrengthLow.visible=false
		$StrengthLowEmpty.visible=false
	elif strength_category=="Medium":
		$StrengthLowEmpty.visible=false
		$StrengthLow.visible=true
	else:
		$StrengthLowEmpty.visible=true


func _on_generator_pressed():
	get_tree().change_scene_to_file("res://scenes/passwordGenerator.tscn")


func _on_saver_pressed():
	get_tree().change_scene_to_file("res://scenes/savedPasswords.tscn")
