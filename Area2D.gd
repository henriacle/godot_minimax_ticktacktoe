extends Area2D

signal hit

var mouseIn = false
export (int) var posicao = false setget set_value

func set_value(value):
	posicao = value

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _input(event):
	if(mouseIn && event.is_action_pressed("click")):
		emit_signal("hit", posicao)

func _on_Area2D_mouse_entered():
	mouseIn = true
	pass # Replace with function body.


func _on_Area2D_mouse_exited():
	mouseIn = false
	pass # Replace with function body.
	
func setFrame(frame):
	$acao.frame = frame
