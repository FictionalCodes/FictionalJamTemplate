class_name LoadData extends RefCounted

var load_path: String
var load_finished_callback: Callable
var progress_update: Callable
var completed: bool = false
var type_hint: String
var loaded_resource: Resource

var last_loaded_percent = 0

func _init(path: String, hint: String = "", complete: Callable = Callable(), progress: Callable = Callable()) -> void:
	load_path = path
	load_finished_callback = complete
	type_hint = hint
	progress_update = progress
	
func poll_load() -> Error:
	var progress = []
	var state = ResourceLoader.load_threaded_get_status(load_path, progress)
	last_loaded_percent = progress[0]
	progress_update.call_deferred(self)

	match state:
		ResourceLoader.THREAD_LOAD_LOADED:
			# as long as we have a callback, do it
			if !load_finished_callback.is_null():
				loaded_resource = ResourceLoader.load_threaded_get(load_path)
				load_finished_callback.call_deferred(self)
			completed = true
			return OK
		#-----------------------------------
		[ResourceLoader.THREAD_LOAD_FAILED, ResourceLoader.THREAD_LOAD_INVALID_RESOURCE]:
			completed = true
			load_finished_callback.call_deferred(null)
			return Error.ERR_CANT_ACQUIRE_RESOURCE

		_: 
			return OK

func start_load() -> Error:
	return ResourceLoader.load_threaded_request(load_path, type_hint)
