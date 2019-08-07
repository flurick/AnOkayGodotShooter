extends Spatial

#stock stats
var flash = 2

#current stats
var flash_timer = 0

func _process(delta):
	flash_timer -= 1
	if flash_timer == 0:
		reset()

func reset():
	$Flash.visible = false
	set_process(false)
	$AudioStreamPlayer3D.play()

func use():
	$Flash.visible = true
	flash_timer = flash
	set_process(true)
	if $Trajectory.is_colliding():
		var new:Sprite3D = $"Impact Area".duplicate()
		get_tree().root.add_child(new) 
		new.rotation = $Trajectory.get_collision_normal()
		new.visible = true
		new.scale = Vector3.ONE * 0.01
		new.transform.origin = $Trajectory .get_collision_point()

func _on_Collision_visibility_changed():
#	if $Collision.is_colliding():
	pass

