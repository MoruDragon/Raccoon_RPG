extends Sprite2D

@export var on_screen_offset: Vector2 = Vector2(.5, -5)
@export var screen_margin: float = 4
@export var smoothing_speed: float = 8

var camera_node: Camera2D

# Called when the node enters the scene tree for the first time.
func _ready():
	camera_node = get_viewport().get_camera_2d()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if not camera_node:
		camera_node = get_viewport().get_camera_2d()
		return
	
	var target_global_position: Vector2 = get_parent().global_position
	var viewport_dimensions: Vector2 = get_viewport().get_visible_rect().size
	var screen_coordinates: Vector2 = (target_global_position - camera_node.global_position) * camera_node.zoom + viewport_dimensions * .5
	var screen_inset_rectangle: Rect2 = Rect2(Vector2.ZERO, viewport_dimensions).grow(-screen_margin)

	var target_display_position: Vector2
	var target_display_rotation: float

	if screen_inset_rectangle.has_point(screen_coordinates):
		target_display_position = target_global_position + on_screen_offset
		target_display_rotation = 0.0
	else:
		var clamped_x = clamp(screen_coordinates.x, screen_margin, viewport_dimensions.x - screen_margin)
		var clamped_y = clamp(screen_coordinates.y, screen_margin, viewport_dimensions.y - screen_margin)
		var clamped_screen_coords: Vector2 = Vector2(clamped_x, clamped_y)
		
		target_display_position = camera_node.global_position + (clamped_screen_coords - viewport_dimensions * .5 / camera_node.zoom)
		
		var vector_to_target: Vector2 = target_global_position - target_display_position
		target_display_rotation = vector_to_target.angle() - PI * .5
		
	global_position = lerp(global_position, target_display_position, delta*smoothing_speed)
	rotation = lerp(rotation, target_display_rotation, delta*smoothing_speed)
