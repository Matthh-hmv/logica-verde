extends Node2D

const AUDIO_VOLTAR := "res://assets/audios/fases/fase1Nivel1/voltar.wav"

@onready var botaoVoltar: TextureButton = $BotaoVoltar

func _ready() -> void:
	botaoVoltar.pressed.connect(Navegacao.voltar)

	# narra ao passar o mouse e ao receber foco pelo teclado
	botaoVoltar.mouse_entered.connect(Narrador.falar.bind(AUDIO_VOLTAR))
	botaoVoltar.focus_entered.connect(Narrador.falar.bind(AUDIO_VOLTAR))
