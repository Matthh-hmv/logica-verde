extends Area2D
class_name popUpBase

@onready var objeto: Sprite2D = $Objeto
@onready var texto: Sprite2D = $Texto
@onready var anim: AnimationPlayer = $AnimationPlayer


var listaObjetosNaoRenovaveis:Dictionary = {
	0: "res://Assets/Objetos/carro.png",
	1: "res://Assets/Objetos/copo_plastico.png",
	2: "res://Assets/Objetos/Garrafa_de_agua_de_plastico.png",
	3: "res://Assets/Objetos/Moto.png",
	4: "res://Assets/Objetos/sacola_de_plastico.png"
}

var listaTextoNaoRenovaveis:Dictionary ={
	0: "res://Assets/Objetos/textos_popup/texto_carro.png",
	1: "res://Assets/Objetos/textos_popup/texto_copo_plastico.png",
	2: "res://Assets/Objetos/textos_popup/texto_garrafa_de_agua_de_plastico.png",
	3: "res://Assets/Objetos/textos_popup/texto_moto.png",
	4: "res://Assets/Objetos/textos_popup/texto_sacola_de_plastico.png"
}

func _ready() -> void:
	botao.hide()
	visible = false

	
#Textura do popUp
var id:= -1
@onready var botao: TextureButton = $BotaoContinuar

func mostraPopUp(newId:int) -> void:
	id = newId
	setTexturaId()
	await get_tree().create_timer(1).timeout
	anim.play("abrePopUp")
	anim.advance(0) #tira Bug de visualização que estava dando
	visible = true
	await anim.animation_finished
	botao.show()
	# Aqui onde vai narrar o texto
	await botao.pressed
	botao.hide()
	anim.play("fechaPopUp")
	await anim.animation_finished
	visible = false
	
func setTexturaId() -> void: #muda a textura da carta
	if not (listaObjetosNaoRenovaveis.has(id) or listaTextoNaoRenovaveis.has(id)):
		return
	objeto.texture = load(listaObjetosNaoRenovaveis[id])
	texto.texture = load(listaTextoNaoRenovaveis[id])
