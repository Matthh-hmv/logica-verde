extends Node2D

@onready var botaoVoltar: TextureButton = $BotaoVoltar

func _ready() -> void:
	botaoVoltar.pressed.connect(Navegacao.voltar)
