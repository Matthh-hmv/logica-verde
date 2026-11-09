extends Node2D

@onready var campoNome: LineEdit = %CampoNome
@onready var botaoComecar: TextureButton = $BotaoComecar


func _ready() -> void:
	print(campoNome)
	print(botaoComecar)
	botaoComecar.pressed.connect(aoApertarComecar)

func aoApertarComecar() -> void:
	var nomeDigitado: String = campoNome.text.strip_edges()
	if nomeDigitado.is_empty():
		campoNome.grab_focus()
		return
	Aluno.nome = nomeDigitado
	print(Aluno.nome)
	Navegacao.irPara("res://cenas/fase 1.1 e 1.2/fase_1_1.tscn")
