class_name LoadData extends RefCounted

var load_path: String
var load_finished_callback: Callable

func _init(path: String, callback: Callable) -> void:
	load_path = path
	load_finished_callback = callback
	
