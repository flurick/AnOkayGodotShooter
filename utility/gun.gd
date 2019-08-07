extends Node

#stock stats
var flash = 3

#current stats
var flash_timer = 0

func _process(delta):
	flash_timer -= 1
	if flash_timer == 0:
		reset()

func reset():
	$Sprite3D.visible = false
	set_process(false)
	$AudioStreamPlayer3D.play()

func use():
	$Sprite3D.visible = true
	flash_timer = flash
	set_process(true)

func _on_Collision_visibility_changed():
#	if $Collision.is_colliding():
	pass

