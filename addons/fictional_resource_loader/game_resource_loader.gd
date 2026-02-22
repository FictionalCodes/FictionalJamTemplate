class_name GameResourceLoader 
extends Node

var currently_loading:Array[LoadData]
var queue: Array[LoadData]

## Load a Resource
## [param type_hint] is the TYPE NAME of the thing you want to load
func start_load_resource(path: String, type_hint:String = "", complete: Callable = Callable()) -> Error:
	if !ResourceLoader.exists(path):
		return Error.ERR_DOES_NOT_EXIST

	var error = ResourceLoader.load_threaded_request(path, type_hint)
	
	if error != Error.OK || complete.is_null():
		return error
	
	return Error.OK
