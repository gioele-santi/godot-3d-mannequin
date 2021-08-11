extends Area
class_name PickHand

# I need a container where to move all other nodes. It should always keep the same loc/rot relative to player position to have better direction with throw

var skin: Mannequiny = null
var pickable_object: Pickable = null 
var hand_ik: SkeletonIK # I need some kind of easy setup, but it must always be child of skeleton

onready var right_hand := $HandRight
onready var anim_player := $AnimationPlayer

var picking := false # <- this should be a state

# Throw
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
	if pickable_object:
		if Input.is_action_pressed('fire'):
			# start strength, derive from movement speed
			strength = min(max_strength, strength + delta * strength_speed)
		elif Input.is_action_just_released('fire'):
			anim_player.play('throw')

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed('interact') and pickable_object:
		picking = true
		pickable_object.get_picked_by(right_hand)
		pickable_object.highlight = false
		hand_ik.start()
		
	if event.is_action_pressed('fire') and pickable_object:
		anim_player.play('throw_charge')

func release_object() -> void:
	var dir := global_transform.basis.z.normalized() * strength + Vector3(0,5,0)
	pickable_object.get_thrown(dir)
	yield(get_tree().create_timer(1.0), "timeout")
	pickable_object = null 
	picking = false

func reset_hand() -> void:
	hand_ik.stop()
	strength = 0.0

func _on_PickHand_body_entered(body: Node) -> void:
	if picking:
		return
	# add animation for picking
	if body.is_in_group("pickable"):
		print("Can pick")
		body.highlight = true
		pickable_object = body

func _on_PickHand_body_exited(body: Node) -> void:
	if body.is_in_group("pickable") and not picking:
		print("Pickable exited")
		body.highlight = false
		pickable_object = null
