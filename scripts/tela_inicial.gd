extends Node2D

@onready var botaoComecar: TextureButton = $BotaoComecar
@onready var botaoRelatorio: TextureButton = $BotaoRelatorio
@onready var botaoSobre: TextureButton = $BotaoSobre
@onready var botaoSair: TextureButton = $BotaoSair

	
func _ready() -> void:
	botaoComecar.pressed.connect(onComecarPressed)
	botaoRelatorio.pressed.connect(onRelatorioPressed)
	botaoSobre.pressed.connect(onSobrePressed)
	botaoSair.pressed.connect(onSairPressed)

func onComecarPressed() -> void:
	Navegacao.irPara("res://cenas/telaNome.tscn")

func onRelatorioPressed() -> void:
	pass

func onSobrePressed() -> void:
	Navegacao.irPara("res://cenas/telaSobre.tscn")

func onSairPressed() -> void:
	get_tree().quit()
