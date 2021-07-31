extends Area
class_name PickHand

var picking := false

var hand_ik: SkeletonIK
# non optimal, it should be in the same scene
#later try moving ik inside and see if it works
# then I will need some kind of easy setup, maybe IK needs to be tailored anyway

func _ready() -> void:
	yield(owner, "ready")
	var parent = get_parent()
#	add_to_group("picker")
	hand_ik = parent.get_node('HandRIK')

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed('fire'):
		print("Fire action")

#add Tween and store default (relative) position
# add animations for one handed attacks (it could be a FSM per se)

func _on_HandRight_body_entered(body: Node) -> void:
	if picking:
		return
	# add animation for picking
	if body.is_in_group("pickable"):
		body.get_picked_by(self)
		picking = true
		hand_ik.start()
