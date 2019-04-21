extends Button

signal restart

var mouseIn = false

func _input(event):
	if(mouseIn && event.is_action_pressed("click")):
		print("emitir sinal")
		emit_signal("restart")

func _on_reiniciar_mouse_entered():
	mouseIn = true
	pass # Replace with function body.


func _on_reiniciar_mouse_exited():
	mouseIn = false
	pass # Replace with function body.
