extends Area2D

# Exposes a direct interaction entrypoint called by the player trigger detector.
func interact() -> void:
	# Reference the parent StaticBody2D node representing the NPC.
	var parent_node: Node = get_parent()
	
	# Verify that the parent node implements the interact method.
	if parent_node.has_method("interact"):
		# Delegate execution to the parent script to start the dialogue sequence.
		parent_node.interact()
