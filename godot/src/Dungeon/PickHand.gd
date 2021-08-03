extends Area
class_name PickHand

var skin: Mannequiny = null
var pick_object: Pickable = null 
var hand_ik: SkeletonIK

var strength := 0.0
export (float, 2.0, 10.0) var strength_speed = 5.0
export (float, 5.0, 20.0) var max_strength := 10.0
# non optimal, it should be in the same scene
#later try moving ik inside and see if it works
# then I will need some kind of easy setup, maybe IK needs to be tailored anyway

func _ready() -> void:
	yield(owner, "ready")
	var skeleton = get_parent()
	skin = skeleton.get_parent().get_parent()
#	add_to_group("picker")
	hand_ik = skeleton.get_node('HandRIK')

func _process(delta: float) -> void:
	if pick_object:
		if Input.is_action_pressed('fire'):
			strength = min(max_strength, strength + delta * strength_speed)
			print(strength)
		elif Input.is_action_just_released('fire'):
			hand_ik.stop()
			var dir := global_transform.basis.z.normalized() * strength + Vector3(0,5,0)
			pick_object.get_thrown(dir)
			yield(get_tree().create_timer(1.0), "timeout")
			pick_object = null
			strength = 0.0

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed('interact'):
		print("interact")
#	if event.is_action_pressed('fire') and pick_object:
#		hand_ik.stop()
#		var dir := global_transform.basis.z.normalized() * strength + Vector3(0,5,0)
#		pick_object.get_thrown(dir)
#		yield(get_tree().create_timer(1.0), "timeout")
#		pick_object = null

#add Tween and store default (relative) position
# add animations for one handed attacks (it could be a FSM per se)

func _on_HandRight_body_entered(body: Node) -> void:
	if pick_object:
		return
	# add animation for picking
	if body.is_in_group("pickable"):
		body.get_picked_by(self)
		pick_object = body
		hand_ik.start()
