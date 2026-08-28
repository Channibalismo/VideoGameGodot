extends VBoxContainer

@export var folder_path: String = ""
@export var slide_width: float = 640.0

@export_multiline var placeholder_text: String = ""  # shown if folder_path is empty/missing

@onready var status_label: Label = Label.new()


func _ready() -> void:
	add_theme_constant_override("separation", 12)

	if folder_path == "":
		_show_status(placeholder_text if placeholder_text != "" else "No slides linked yet.")
		return

	var dir := DirAccess.open(folder_path)
	if dir == null:
		_show_status("Slides not found for this lesson.")
		return

	var filenames: Array = []
	dir.list_dir_begin()
	var f := dir.get_next()
	while f != "":
		if not dir.current_is_dir() and (f.ends_with(".jpg") or f.ends_with(".jpeg") or f.ends_with(".png")):
			filenames.append(f)
		f = dir.get_next()
	dir.list_dir_end()

	if filenames.is_empty():
		_show_status("No slide images found in this lesson's folder.")
		return

	filenames.sort() 

	for filename in filenames:
		var tex: Texture2D = load(folder_path.path_join(filename))
		if tex == null:
			continue
		var rect := TextureRect.new()
		rect.texture = tex
		rect.expand_mode = TextureRect.EXPAND_FIT_WIDTH_PROPORTIONAL
		rect.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT
		rect.custom_minimum_size = Vector2(slide_width, 0)
		rect.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
		add_child(rect)


func _show_status(text: String) -> void:
	status_label.text = text
	status_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	add_child(status_label)
