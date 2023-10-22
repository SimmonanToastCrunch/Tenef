extends Node


# these DO NOT close the file!
# this must be done manually!
func _open_file_r(file_path) -> File:
	var file = File.new()
	file.open(file_path, File.READ)
	return file


func _open_file_w(file_path) -> File:
	var file = File.new()
	file.open(file_path, file.WRITE)
	return file


func _open_file_rw(file_path) -> File:
	var file = File.new()
	file.open(file_path, file.READ_WRITE)
	return file


func _open_file_text(file_path) -> String:
	var file = _open_file_r(file_path)
	var text = file.get_as_text()
	file.close()
	return text


func _open_file_dict(file_path):
	var file = _open_file_r(file_path)
	var ret = file.get_as_text()
	ret = _to_dict(ret)
	file.close()
	return ret


func _to_dict(json):
	return JSON.parse(json).result


func _to_json(dict, indent = ""):
	return JSON.print(dict, indent)

