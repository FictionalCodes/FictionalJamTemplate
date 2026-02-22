class_name GameResourceLoader 
extends Node

var currently_loading:Array[LoadData]
var queue: Array[LoadData]

var max_loading : int = 4

var poll_interval : float = 0.1

func _init() -> void:
	pass

## Load a Resource
## [param type_hint] is the TYPE NAME of the thing you want to load
func start_load_resource(path: String, type_hint:String = "", complete: Callable = Callable()) -> Error:
	if !ResourceLoader.exists(path):
		return Error.ERR_DOES_NOT_EXIST

	var error := ResourceLoader.load_threaded_request(path, type_hint)
	
	if error != Error.OK:
		return error
	
	var new_load := LoadData.new(path, complete)

	# add to the currently loading set if we havent hit max, otherwise add to the queue
	currently_loading.push_back(new_load) if currently_loading.size() < max_loading else queue.push_back(new_load)
		
	return Error.OK

var poll_current : float = 0.0
func _process(delta: float) -> void:
	# add the current time, then if its less than the interval, leave method early
	poll_current += delta
	if poll_current < poll_interval:
		return

	# check load status of each one
	for i in range(currently_loading.size()-1,0):
		var curr = currently_loading[i]
		var progress = []
		var state = ResourceLoader.load_threaded_get_status(curr.load_path, progress)

		match state:
			ResourceLoader.THREAD_LOAD_LOADED:

				# as long as we have a callback, do it
				if !curr.load_finished_callback.is_null():
					var loaded_resouce = ResourceLoader.load_threaded_get(curr.load_path)
					curr.load_finished_callback.call_deferred(loaded_resouce)
				curr.completed = true
			#-----------------------------------
			[ResourceLoader.THREAD_LOAD_FAILED, ResourceLoader.THREAD_LOAD_INVALID_RESOURCE]:
				curr.completed = true

		if curr.completed:
			currently_loading.remove_at(i)	
	
	# now stack the currently loading array with the next resource
	while currently_loading.size() < max_loading and !queue.is_empty():
		currently_loading.push_back(queue.pop_front())

			


	
