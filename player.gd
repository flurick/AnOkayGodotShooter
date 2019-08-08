extends KinematicBody

#input
var mouse_sense_x = -0.005
var mouse_sense_y = -0.005
var input_movement = Vector3(0,0,0)
var output_movement  = Vector3(0,0,0)
var speed_walking = 200
var speed_running = 400
var is_speed_limited = false
var down = Vector3(0,1,0)
var limit_neck_angle = 90
onready var forward = -get_global_transform().basis.z
onready var right = get_global_transform().basis.x

#gravity
var gravity = 10
var speed_jump = 20
var overheat_jump = 0
var overheat_limit_jump = 30

#aim
var is_aiming = true


func _ready():
	
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
	$"Spawn Audio".play()



func _process(delta):

	#reset
	input_movement = Vector3(0,0,0)
	output_movement = Vector3(0,0,0)

	#set
	input_movement.z = Input.get_action_strength("Forward") - Input.get_action_strength("Backward")
	input_movement.x = Input.get_action_strength("Right") - Input.get_action_strength("Left")
	input_movement = input_movement.normalized()
	forward = -get_global_transform().basis.z
	right = get_global_transform().basis.x

	#apply
	output_movement += forward * input_movement.z
	output_movement += right * input_movement.x
	if is_speed_limited:
		move_and_slide(output_movement*speed_walking*delta, down)
	else:
		move_and_slide(output_movement*speed_running*delta, down)
	
	#gravity
	move_and_slide(-down*gravity, down)


func _input(event):

	if event.is_action_type():
		
		
		if event.is_action_pressed("Configure"):
			is_aiming = !is_aiming
			if is_aiming:
				Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
				$Camera/ui.visible = false
			else:
				Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
				$Camera/ui.visible = true

		if event.is_action("ui_cancel"):
			get_tree().reload_current_scene()

		if event.is_action("light"):
			if !event.is_pressed():
				find_node("SpotLight").visible = !find_node("SpotLight").visible

		if is_aiming:
			if event.is_action("use"):
				if event.is_pressed():
					$Camera/hand/gun.use()
	
			if event.is_action("use_alt"):
				$AnimationPlayer.playback_speed = 8
				if event.is_pressed():
					is_speed_limited = true
					$AnimationPlayer.play("aim")
				else:
					is_speed_limited = false
					$AnimationPlayer.play_backwards("aim")

	if is_aiming:
		if event is InputEventMouseMotion:
			rotate_y(event.get_relative().x * mouse_sense_x )
			$Camera.rotate_x(event.get_relative().y * mouse_sense_y )
			$Camera.rotation_degrees.x = clamp($Camera.rotation_degrees.x, -limit_neck_angle, limit_neck_angle)