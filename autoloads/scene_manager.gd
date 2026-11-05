extends Node

var target_marker_tag: String = ""

func transition_to_map(target_scene_path: String, marker_tag: String) -> void:
	
	if target_scene_path.is_empty():
		push_error("[SceneManager] ERROR: target_scene_path is empty. Set it in the Inspector dock.")
		return

	if not ResourceLoader.exists(target_scene_path):
		push_error("[SceneManager] ERROR: Scene file does not exist at path: " + target_scene_path)
		return

	target_marker_tag = marker_tag
	var err: Error = get_tree().change_scene_to_file(target_scene_path)
	if err != OK:
		push_error("[SceneManager] ERROR: change_scene_to_file failed with error code: " + str(err))
		return
