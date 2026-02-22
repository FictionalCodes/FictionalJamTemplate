class_name LoadData extends RefCounted

var load_path: String
var load_finished_callback: Callable
var completed: bool = false
var type_hint: String

func _init(path: String, hint: String = "", callback: Callable = Callable()) -> void:
	load_path = path
	load_finished_callback = callback
	type_hint = hint
	
