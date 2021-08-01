extends RigidBody
class_name Pickable

export (NodePath) var target_path = null
var _target: Spatial = null

func _ready() -> void:
	# set as pickable group
	add_to_group("pickable")
	if target_path != null:
		_target = get_node(target_path)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if _target != null:
		self.global_transform.origin = _target.global_transform.origin
		self.global_transform.basis = _target.global_transform.basis

func get_picked_by(picker: Spatial) -> void:
	_target = picker
	mode = MODE_KINEMATIC

func get_thrown(direction: Vector3) -> void:
	_target = null
	mode = MODE_RIGID
	apply_central_impulse(direction)
	# apply force for throw action
