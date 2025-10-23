extends CanvasLayer

@export var scene_txt_file = "res://json/engl_dialogue.json"


var scene_text = {}
var selected_text = []
var in_progress = false

@onready var bkgnd = $Backgnd
@onready var txt_label = $Label

func _ready():
	bkgnd.visible = false
	txt_label.visible = false
	scene_text = load_scene_txt()
	print(scene_text)
	DialogueSignalBus.display_dialog.connect(self.on_display_dialog)
	
func load_scene_txt():
	var f = FileAccess.open(scene_txt_file, FileAccess.READ)
	#if true:#f.file_exists(scene_txt_file):
	#	f.open(scene_txt_file,FileAccess.READ)
	return JSON.parse_string(f.get_as_text())

func show_text():
	txt_label.text = selected_text.pop_front()
	
func next_line():
	if selected_text.size() > 0:
		show_text()
	else:
		finish()

func finish():
	txt_label.text = ""
	bkgnd.visible = false
	txt_label.visible = false
	in_progress = false
	get_tree().paused = false	

func on_display_dialog(text_key):
	if in_progress:
		next_line()
	else:
		get_tree().paused = true
		bkgnd.visible = true
		txt_label.visible = true
		in_progress = true
		selected_text = scene_text[text_key].duplicate()
		show_text()
	
