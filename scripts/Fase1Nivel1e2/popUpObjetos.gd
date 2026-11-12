extends Area2D
class_name popUpBase

@onready var objeto: Sprite2D = $Objeto
@onready var texto: Sprite2D = $Texto
@onready var anim: AnimationPlayer = $AnimationPlayer
@onready var botao: TextureButton = $BotaoContinuar
var id:= -1
var nivelAtual: int = 1

const PASTA_AUDIO := {
	1: "res://Assets/Áudios/Fases/Fase 1.1 (Manuela)/",
	2: "res://Assets/Áudios/Fases/Fase 1.2 (Nickole)/",
	3: "res://Assets/Áudios/Fases/Fase 1.3 (Matheus)/"
}

const AUDIO_CONTINUAR := "Continuar.wav"

const AUDIO_ERRO := {
	1: "res://Assets/Áudios/Fases/Fase 1.1 (Manuela)/Ops, essas cartas não são pares!.wav",
	2: "res://Assets/Áudios/Fases/Fase 1.2 (Nickole)/Ops, essas cartas nao sao pares!.wav",
	3: "res://Assets/Áudios/Fases/Fase 1.3 (Matheus)/Ops, essas cartas não são pares!.wav"
}

const AUDIO_VITORIA := {
	1: "res://Assets/Áudios/Fases/Fase 1.1 (Manuela)/Parabéns! Você achou todos os pares!.wav",
	2: "res://Assets/Áudios/Fases/Fase 1.2 (Nickole)/Parabens, você achou todos os pares!.wav",
	3: "res://Assets/Áudios/Fases/Fase 1.3 (Matheus)/Parabens, você achou todos os pares!.wav"
}

const AUDIO_DESCRICAO := {
	1: {
		0: "Carro- solta fumaça que suja o ar..wav",
		1: "Copo de plástico- usamos uma vez e jogamos fora.wav",
		2: "Garrafa de plástico- usamos uma vez e vira lixo.wav",
		3: "Moto- queima combustível e solta fumaça.wav",
		4: "Sacola de plástico - usamos uma vez e vira lixo.wav"
	},
	2: {
		0: "Onibus Popup.wav",
		1: "Caneca Popup.wav",
		2: "Garrafa reutilizavel Popup.wav",
		3: "Bicicleta Popup.wav",
		4: "Ecobag Popup.wav"
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
	botao.mouse_entered.connect(_falarContinuar)
	botao.focus_entered.connect(_falarContinuar)


# Monta o caminho completo do áudio de acordo com o nível
func _caminho(arquivo: String) -> String:
	return PASTA_AUDIO.get(nivelAtual, "") + arquivo


func _falarContinuar() -> void:
	Narrador.falar(_caminho(AUDIO_CONTINUAR))


#Textura do popUp

func mostraPopUp(newId:int, nivel: int) -> void:
	id = newId
	nivelAtual = nivel
	setTexturaId(nivel)
	await get_tree().create_timer(1).timeout
	anim.play("abrePopUp")
	anim.advance(0) #tira Bug de visualização que estava dando
	visible = true
	await anim.animation_finished

	# o botão só aparece depois que o aluno ouvir tudo
	if AUDIO_DESCRICAO.has(nivel) and AUDIO_DESCRICAO[nivel].has(id):
		await Narrador.falarEEsperar(_caminho(AUDIO_DESCRICAO[nivel][id]))

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
	
func erroPar(nivel: int) -> void:
	nivelAtual = nivel
	anim.play("abreErro")
	visible = true
	if AUDIO_ERRO.has(nivel):
		await Narrador.falarEEsperar(_caminho(AUDIO_ERRO[nivel]))
	await get_tree().create_timer(0.5).timeout
	anim.play("fechaErro")
	await anim.animation_finished
	visible = false

func finalizaMemoria(nivel: int) -> void:
	nivelAtual = nivel
	anim.play("abreVitoria")
	visible = true
	if AUDIO_VITORIA.has(nivel):
		await Narrador.falarEEsperar(_caminho(AUDIO_VITORIA[nivel]))
	botao.show()
	await botao.pressed
	botao.hide()
	anim.play("fechaVitoria")
	await anim.animation_finished
	visible = false
