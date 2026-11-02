extends Area2D
class_name CartaBase

signal clicked(carta: CartaBase)

@onready var anim: AnimationPlayer = $Anim
@onready var textura_frente: Sprite2D = $TexturaFrente

var isFlipped: bool = false
var isLocked: bool = false

var id:int = -1

var listaTexturaPorNivel:Dictionary = {
	1: {
		0: "res://Assets/Cartas/cartaCarro.png",
		1: "res://Assets/Cartas/cartaCopoPlastico.png",
		2: "res://Assets/Cartas/cartaGarrafaPlastico.png",
		3: "res://Assets/Cartas/cartaMoto.png",
		4: "res://Assets/Cartas/cartaSacola.png"
	},
	2:{
		0: "res://Assets/Cartas/cartaOnibus.png",
		1: "res://Assets/Cartas/cartaCaneca.png",
		2: "res://Assets/Cartas/cartaGarrafaReutilizavel.png",
		3: "res://Assets/Cartas/cartaBicicleta.png",
		4: "res://Assets/Cartas/cartaEcobag.png"
	}
}

func _ready() -> void:
	pass
	
	
func _input_event(_viewport: Viewport, event: InputEvent, _shape_idx: int) -> void:
	if isLocked:
		return
		
	if event is InputEventMouseButton and event.pressed:
		emit_signal("clicked", self)
			

#TEXTURA DAS CARTAS

func setTextura(newId:int, nivel: int) -> void:
	id = newId
	setTexturaId(nivel)
	await get_tree().create_timer(1.5).timeout
	anim.play("escondeCarta")
	isFlipped = false
	isLocked = false
	
func setTexturaId(nivel: int) -> void: #muda a textura da carta
	if not listaTexturaPorNivel.has(nivel):
		return
	var listaTextura: Dictionary  = listaTexturaPorNivel[nivel]
	if not listaTextura.has(id):
		return
	textura_frente.texture = load(listaTextura[id])
	
func aberta() -> void: #carta fechada
	if isLocked or isFlipped:
		return
	isFlipped = true
	anim.play("mostraCarta")
	
func fechada() -> void: #carta aberta
	if isLocked:
		return
	isFlipped = false
	anim.play("escondeCarta")
	
func par() -> void: #par achado da carta
	isFlipped = true
	isLocked = true
	var tween:= create_tween()
	tween.tween_property(self, "modulate:a", 0.5, 0.3)
	
	
	
	
	
	
	
