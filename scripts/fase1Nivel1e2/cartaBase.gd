extends Area2D
class_name CartaBase

signal clicked(carta: CartaBase)

@onready var anim: AnimationPlayer = $Anim
@onready var textura_frente: Sprite2D = $TexturaFrente

var isFlipped: bool = false
var isLocked: bool = false
const PASTA_AUDIO := {
	1: "res://assets/audios/fases/fase1Nivel1/",
	2: "res://assets/audios/fases/fase1Nivel2/"
}

const listaAudioPorNivel := {
	1: {
		0: "carro.wav",
		1: "copoDePlastico.wav",
		2: "garrafaDePlastico.wav",
		3: "moto.wav",
		4: "sacolaDePlastico.wav"
	},
	2: {
		0: "onibus.wav",
		1: "caneca.wav",
		2: "garrafaReutilizavel.wav",
		3: "bicicleta.wav",
		4: "ecobag.wav"
	}
}
var nivelAtual: int = 1

var id:int = -1

var listaTexturaPorNivel:Dictionary = {
	1: {
		0: "res://assets/cartas/cartaCarro.png",
		1: "res://assets/cartas/cartaCopoPlastico.png",
		2: "res://assets/cartas/cartaGarrafaPlastico.png",
		3: "res://assets/cartas/cartaMoto.png",
		4: "res://assets/cartas/cartaSacola.png"
	},
	2:{
		0: "res://assets/cartas/cartaOnibus.png",
		1: "res://assets/cartas/cartaCaneca.png",
		2: "res://assets/cartas/cartaGarrafaReutilizavel.png",
		3: "res://assets/cartas/cartaBicicleta.png",
		4: "res://assets/cartas/cartaEcobag.png"
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
	nivelAtual = nivel
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
	
func aberta() -> void:
	if isLocked or isFlipped:
		return
	isFlipped = true
	anim.play("mostraCarta")
	if listaAudioPorNivel.has(nivelAtual) and listaAudioPorNivel[nivelAtual].has(id):
		Narrador.falar(PASTA_AUDIO[nivelAtual] + listaAudioPorNivel[nivelAtual][id])
	
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
	
	
	
	
	
	
	
