extends Area2D

var mouseIn = false;

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if(mouseIn && Input.is_action_pressed("click")):
		print("hello")

func _on_Control_mouse_enter():
	print("mouse enter")

func _on_Area2D_mouse_entered():
	print("entered")
	mouseIn = true
	
func _on_Area2D_mouse_exited():
	mouseIn = false
