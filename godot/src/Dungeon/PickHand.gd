extends Area
class_name PickHand

# I need a container where to move all other nodes. It should always keep the same loc/rot relative to player position to have better direction with throw

var skin: Mannequiny = null
var pick_object: Pickable = null 
var hand_ik: SkeletonIK # I need some kind of easy setup, but it must always be child of skeleton

onready var right_hand := $HandRight
onready var anim_player := $AnimationPlayer

var strength := 0.0
export (float, 2.0, 10.0) var strength_speed = 5.0
export (float, 5.0, 20.0) var max_strength := 10.0

# make it a  FSM, states will be IDLE, CHARGE (throw), MOVE (either walk or run), check how to manage attacks

func _ready() -> void:
	yield(owner, "ready")
	var skeleton = get_parent()
	skin = skeleton.get_parent().get_parent()
#	add_to_group("picker")
	hand_ik = skeleton.get_node('HandRIK')

func _process(delta: float) -> void:
	if pick_object:
		if Input.is_action_pressed('fire'):
			# start strength, derive from movement speed
			strength = min(max_strength, strength + delta * strength_speed)
		elif Input.is_action_just_released('fire'):
			anim_player.play('throw')
			

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed('interact'):
		print("interact")
	if event.is_action_pressed('fire') and pick_object:
		anim_player.play('throw_charge')

func release_object() -> void:
	var dir := global_transform.basis.z.normalized() * strength + Vector3(0,5,0)
	pick_object.get_thrown(dir)
	yield(get_tree().create_timer(1.0), "timeout")
	pick_object = null 

func reset_hand() -> void:
	hand_ik.stop()
	strength = 0.0

#add Tween and store default (relative) position
# add animations for one handed attacks (it could be a FSM per se)

func _on_PickHand_body_entered(body: Node) -> void:
	if pick_object:
		return
	# add animation for picking
	if body.is_in_group("pickable"):
		body.get_picked_by(right_hand)
		pick_object = body
		hand_ik.start()
