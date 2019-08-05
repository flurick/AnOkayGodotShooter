extends KinematicBody

#input
var mouse_sense_x = -0.005
var mouse_sense_y = -0.005
var input_movement = Vector3(0,0,0)
var output_movement  = Vector3(0,0,0)
var speed_walking = 100
var speed_running = 300
var down = Vector3(0,1,0)
var limit_neck_angle = 90
var forward = -get_global_transform().basis.z
var right = get_global_transform().basis.x

#gravity
var gravity = 10
var speed_jump = 20
var overheat_jump = 0
var overheat_limit_jump = 30

#aim
var is_aiming = false


func _ready():

	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


var stress = 0.1
var senses = [forward]
var ai_jump = false
var target = "../Player"

func ai():

#	rotate_y(randf()*0.1)
	look_at( get_node(target).transform.origin, Vector3(0,1,0) )
#	$Camera.rotate_x(event.get_relative().y * mouse_sense_y )
#	$Camera.rotation_degrees.x = clamp($Camera.rotation_degrees.x, -limit_neck_angle, limit_neck_angle)

	return

func _process(delta):

	#reset
	input_movement = Vector3(0,0,0)
	output_movement = Vector3(0,0,0)

	#set
	ai()
#	input_movement.x = senses.front().z #left
	input_movement.z = -senses.front().z #forward
	input_movement = input_movement.normalized() * stress
	forward = -get_global_transform().basis.z
	right = get_global_transform().basis.x

	#apply
	output_movement += forward * input_movement.z
	output_movement += right * input_movement.x
	move_and_slide(output_movement*speed_running*delta, down)

	#gravity
	if ai_jump and overheat_jump < overheat_limit_jump:
		move_and_slide(down*speed_jump, down)
		overheat_jump += 1
	else:
		move_and_slide(-down*gravity, down)
	if is_on_floor():
		overheat_jump = 0
#	$Camera/ui/Label.text = str( overheat_jump, "floor:",is_on_floor(),"ceiling:",is_on_ceiling(),"wall:",is_on_wall() )



#func _input(event):

#	if event.is_action_type():
#
#		if event.is_action("ui_cancel"):
#			get_tree().reload_current_scene()
#
#		if event.is_action("light"):
#			if !event.is_pressed():
#				find_node("SpotLight").visible = !find_node("SpotLight").visible
#
#		if event.is_action("use"):
#			if event.is_pressed():
#				$Camera/hand/gun.use()
#
#		if event.is_action("use_alt"):
#			$AnimationPlayer.playback_speed = 5
#			if event.is_pressed():
#				$AnimationPlayer.play("aim")
#			else:
#				$AnimationPlayer.play_backwards("aim")
#
#	if event is InputEventMouseMotion:
#		rotate_y(event.get_relative().x * mouse_sense_x )
#		$Camera.rotate_x(event.get_relative().y * mouse_sense_y )
#		$Camera.rotation_degrees.x = clamp($Camera.rotation_degrees.x, -limit_neck_angle, limit_neck_angle)