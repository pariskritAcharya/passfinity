extends Control
#when elements load up get assigned to varibles
@onready var display=$display
@onready var Name =$name
@onready var Password=$password
@onready var searchBar=$searchBar


var displayText=""#variable that gets displayed 
var string_array = [] # an empty array to store the strings
var temp_array = []
var recentPassword=""#for checking if anything has been changed before saving 
var qrcode=false#if qr code needs to visible or not
var filePath = "user://save.txt"
var TEMP = "user://temp.txt"
func _ready():
	$AnimationPlayer.play("boot")
	display.text=""
	#checking and displaying password
	if FileAccess.file_exists(filePath):
		var file = FileAccess.open(filePath,FileAccess.READ)
		displayText=file.get_as_text()
		if displayText=="":
			display.text="save/create some password first"
		else:
			while not file.eof_reached():
				var line = file.get_csv_line(",") # read a line and split by commas
				string_array.append(line) # add the line to the array
		file.close()
		# Sort the array using the custom comparator function
		string_array.sort_custom(compare_by_name)
		var length = string_array.size()
		for i in range(1,length):
				display.text=display.text+str(i)+") "+string_array[i][0]+"   -->  "+string_array[i][1]+"\n"
	else:
		display.text="No file present"

func _input(event):
	if Input.is_action_just_pressed("click") and $QrShader/QRCodeRect.visible:
		$QrShader.visible=false

func _on_button_pressed():
	Global.generatedPassword=Password.text
	#checking if name and password is present and not repeated and saving in file
	if (Name.text!="" and Password.text!=""):
		if !(recentPassword==Global.generatedPassword):
			var file = FileAccess.open(filePath, FileAccess.READ_WRITE)
			file.seek_end()
			file.store_string(Name.text)
			file.store_string(","+Password.text+"\n")
			file.close()
			recentPassword=Global.generatedPassword
			get_tree().change_scene_to_file("res://scenes/savedPasswords.tscn")
	else:
		if Name.text=="":
			Name.placeholder_text="Name : REQUIRED"
		if Password.text=="":
			Password.placeholder_text="Password : REQUIRED"

func _on_back_pressed():
	get_tree().change_scene_to_file("res://scenes/passwordGenerator.tscn")


func compare_by_name(a, b):
	return a[0] < b[0]


#generate qr when button is pressed 
func _on_qrcode_pressed():
	$QrShader/QRCodeRect.data= "Name: "+Name.text+"\n"+"Password: "+Password.text
	$QrShader.visible=true


func _on_search_pressed():
	var search =searchBar.text
	if search=="":
		searchBar.placeholder_text="enter something"
	else:
		find_string(string_array,search)
	


func find_string(array, string):
	var flag =false
	display.text=""
	for i in range(array.size()):
		for j in range(array[i].size()):
			if typeof(array[i][j]) == TYPE_STRING and array[i][j] == string:
				j=0
				display.text=display.text+array[i][j]+"   -->  "+array[i][j+1]+"\n"
				flag=true
	if !flag:
		display.text=searchBar.text+" was not found! Try something else."






func _on_reload_pressed():
	get_tree().change_scene_to_file("res://scenes/savedPasswords.tscn")


func _on_delete_pressed():
	var delete = int(searchBar.text)
	var file = FileAccess.open(TEMP,FileAccess.WRITE_READ)
	var file2 = FileAccess.open(filePath,FileAccess.WRITE)
	for i in range(1,string_array.size()):
		#for j in range(string_array[i].size()):
		if i!=delete:
			var data=string_array[i][0]+","+string_array[i][1]+"\n"
			file.store_string(data)
	var data=file.get_as_text()
	file2.store_string(data)
	file.close()
	get_tree().change_scene_to_file("res://scenes/savedPasswords.tscn")



	


func _on_checker_pressed():
	get_tree().change_scene_to_file("res://scenes/passwordChecker.tscn")
