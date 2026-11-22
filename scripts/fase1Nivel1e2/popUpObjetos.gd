extends Area2D
class_name popUpBase

@onready var objeto: Sprite2D = $Objeto
@onready var texto: Sprite2D = $Texto
@onready var anim: AnimationPlayer = $AnimationPlayer
@onready var botao: TextureButton = $BotaoContinuar
var id:= -1
var nivelAtual: int = 1

const PASTA_AUDIO := {
	1: "res://assets/audios/fases/fase1Nivel1/",
	2: "res://assets/audios/fases/fase1Nivel2/",
	3: "res://assets/audios/fases/fase1Nivel3/"
}

const AUDIO_CONTINUAR := "continuar.wav"

const AUDIO_ERRO := {
	1: "erroPar.wav",
	2: "erroPar.wav",
	3: "erroPar.wav"
}

const AUDIO_VITORIA := {
	1: "parabens.wav",
	2: "parabens.wav",
	3: "parabens.wav"
}

const AUDIO_DESCRICAO := {
	1: {
		0: "carroPopup.wav",
		1: "copoDePlasticoPopup.wav",
		2: "garrafaDePlasticoPopup.wav",
		3: "motoPopup.wav",
		4: "sacolaDePlasticoPopup.wav"
	},
	2: {
		0: "onibusPopup.wav",
		1: "canecaPopup.wav",
		2: "garrafaReutilizavelPopup.wav",
		3: "bicicletaPopup.wav",
		4: "ecobagPopup.wav"
	}
}

var listaObjetoNivel:Dictionary = {
	1: {
		0: "res://assets/objetos/carro.png",
		1: "res://assets/objetos/copoPlastico.png",
		2: "res://assets/objetos/garrafaDeAguaDePlastico.png",
		3: "res://assets/objetos/moto.png",
		4: "res://assets/objetos/sacolaDePlastico.png"
	},
	2: {
		0: "res://assets/objetos/onibus.png",
		1: "res://assets/objetos/caneca.png",
		2: "res://assets/objetos/garrafaReutilizavel.png",
		3: "res://assets/objetos/bicicleta.png",
		4: "res://assets/objetos/ecobag.png"
	}
}

var listaTextoNivel:Dictionary ={
	1: {
		0: "res://assets/objetos/textosPopup/textoCarro.png",
		1: "res://assets/objetos/textosPopup/textoCopoPlastico.png",
		2: "res://assets/objetos/textosPopup/textoGarrafaDeAguaDePlastico.png",
		3: "res://assets/objetos/textosPopup/textoMoto.png",
		4: "res://assets/objetos/textosPopup/textoSacolaDePlastico.png"
		},
	2: {
		0: "res://assets/objetos/textosPopup/textoOnibus.png",
		1: "res://assets/objetos/textosPopup/textoCaneca.png",
		2: "res://assets/objetos/textosPopup/textoGarrafaReutilizavel.png",
		3: "res://assets/objetos/textosPopup/textoBicicleta.png",
		4: "res://assets/objetos/textosPopup/textoEcobag.png"
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
