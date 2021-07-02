extends RigidBody
class_name Pickable

export (NodePath) var target_path = null
var target: Spatial = null

func _ready() -> void:
	# set as pickable group
	if target_path != null:
		target = get_node(target_path)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if target != null:
		self.global_transform.origin = target.global_transform.origin
		self.global_transform.basis = target.global_transform.basis


func _on_HandTorch_body_entered(body: Node) -> void:
	print(body.name)
