extends Area2D
class_name CartaBase 

@onready var anim: AnimationPlayer = $Anim
@onready var textura_frente: Sprite2D = $TexturaFrente

var isFlipped: bool = false
var listaTexturaNãoRenovaveis:Dictionary = {
	0: "res://Assets/Cartas/cartaCarro.png",
	1: "res://Assets/Cartas/cartaCopoPlastico.png",
	2: "res://Assets/Cartas/cartaGarrafaPlastico.png",
	3: "res://Assets/Cartas/cartaMoto.png",
	4: "res://Assets/Cartas/cartaSacola.png"
}

func _ready() -> void:
	randomize()
	var id = randi_range(0,4)
	textura_frente.texture = load(listaTexturaNãoRenovaveis[id])
	

func _input_event(_viewport: Viewport, event: InputEvent, _shape_idx: int) -> void:
		if event is InputEventMouseButton and event.pressed:
			if isFlipped == false: 
				anim.play("mostraCarta")
				isFlipped = true
			else:
				anim.play("escondeCarta")
				isFlipped = false
			
