extends Area2D
class_name popUpBase

@onready var objeto: Sprite2D = $Objeto
@onready var texto: Sprite2D = $Texto
@onready var anim: AnimationPlayer = $AnimationPlayer
@onready var botao: TextureButton = $BotaoContinuar
var id:= -1

const PASTA_AUDIO := "res://Assets/Áudios/Fases/Fase 1.1 (Manuela)/"

const AUDIO_CONTINUAR := PASTA_AUDIO + "Continuar.wav"
const AUDIO_ERRO := PASTA_AUDIO + "Ops, essas cartas não são pares!.wav"
const AUDIO_VITORIA := PASTA_AUDIO + "Parabéns! Você achou todos os pares!.wav"

const listaAudioNivel := {
	1: {
		0: PASTA_AUDIO + "Carro- solta fumaça que suja o ar..wav",
		1: PASTA_AUDIO + "Copo de plástico- usamos uma vez e jogamos fora.wav",
		2: PASTA_AUDIO + "Garrafa de plástico- usamos uma vez e vira lixo.wav",
		3: PASTA_AUDIO + "Moto- queima combustível e solta fumaça.wav",
		4: PASTA_AUDIO + "Sacola de plástico - usamos uma vez e vira lixo.wav"
	}
}


var listaObjetoNivel:Dictionary = {
	1: {
		0: "res://Assets/Objetos/carro.png",
		1: "res://Assets/Objetos/copo_plastico.png",
		2: "res://Assets/Objetos/Garrafa_de_agua_de_plastico.png",
		3: "res://Assets/Objetos/Moto.png",
		4: "res://Assets/Objetos/sacola_de_plastico.png"
	},
	2: {
		0: "res://Assets/Objetos/onibus.png",
		1: "res://Assets/Objetos/caneca.png",
		2: "res://Assets/Objetos/garrafa_reutilizavel.png",
		3: "res://Assets/Objetos/bicicleta.png",
		4: "res://Assets/Objetos/ecobag.png"
	}
}

var listaTextoNivel:Dictionary ={
	1: {
		0: "res://Assets/Objetos/textos_popup/texto_carro.png",
		1: "res://Assets/Objetos/textos_popup/texto_copo_plastico.png",
		2: "res://Assets/Objetos/textos_popup/texto_garrafa_de_agua_de_plastico.png",
		3: "res://Assets/Objetos/textos_popup/texto_moto.png",
		4: "res://Assets/Objetos/textos_popup/texto_sacola_de_plastico.png"
		},
	2: {
		0: "res://Assets/Objetos/textos_popup/texto_onibus.png",
		1: "res://Assets/Objetos/textos_popup/texto_caneca.png",
		2: "res://Assets/Objetos/textos_popup/texto_garrafa_reutilizavel.png",
		3: "res://Assets/Objetos/textos_popup/texto_bicicleta.png",
		4: "res://Assets/Objetos/textos_popup/texto_ecobag.png"
	}
}

func _ready() -> void:
	botao.hide()
	visible = false
	botao.mouse_entered.connect(Narrador.falar.bind(AUDIO_CONTINUAR))
	botao.focus_entered.connect(Narrador.falar.bind(AUDIO_CONTINUAR))


func mostraPopUp(newId:int, nivel: int) -> void:
	id = newId
	setTexturaId(nivel)
	await get_tree().create_timer(1).timeout
	anim.play("abrePopUp")
	anim.advance(0)
	visible = true
	await anim.animation_finished

	# o botão só aparece depois que o aluno ouvir tudo
	if listaAudioNivel.has(nivel) and listaAudioNivel[nivel].has(id):
		await Narrador.falarEEsperar(listaAudioNivel[nivel][id])

	botao.show()
	await botao.pressed
	botao.hide()
	anim.play("fechaPopUp")
	await anim.animation_finished
	visible = false
	
func setTexturaId(nivel: int) -> void: #muda a textura da carta
	if not (listaObjetoNivel.has(nivel) or listaTextoNivel.has(nivel)):
		return
	var listaObjeto: Dictionary  = listaObjetoNivel[nivel]
	var listaTexto: Dictionary = listaTextoNivel[nivel]
	if not (listaObjeto.has(id) and listaTexto.has(id)):
		return
	objeto.texture = load(listaObjeto[id])
	texto.texture = load(listaTexto[id])
	
func erroPar() -> void:
	anim.play("abreErro")
	visible = true
	await Narrador.falarEEsperar(AUDIO_ERRO)
	await get_tree().create_timer(0.5).timeout
	anim.play("fechaErro")
	await anim.animation_finished
	visible = false


func finalizaMemoria() -> void:
	anim.play("abreVitoria")
	visible = true
	await Narrador.falarEEsperar(AUDIO_VITORIA)
	botao.show()
	await botao.pressed
	botao.hide()
	anim.play("fechaVitoria")
	await anim.animation_finished
	visible = false
