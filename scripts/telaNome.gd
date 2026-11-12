extends Node2D

const AUDIO_NOME := "res://Assets/Áudios/Digite seu nome.wav"
const AUDIO_CONTINUAR := "res://Assets/Áudios/Tela inicial/Começar.wav"

@onready var campoNome: LineEdit = %CampoNome
@onready var botaoComecar: TextureButton = $BotaoComecar


func _ready() -> void:
	botaoComecar.pressed.connect(aoApertarComecar)

	# campo de nome: narra ao passar o mouse e ao receber foco pelo teclado
	campoNome.mouse_entered.connect(Narrador.falar.bind(AUDIO_NOME))
	campoNome.focus_entered.connect(aoFocarCampo)

	# botão: narra ao passar o mouse e ao receber foco pelo teclado
	botaoComecar.mouse_entered.connect(Narrador.falar.bind(AUDIO_CONTINUAR))
	botaoComecar.focus_entered.connect(Narrador.falar.bind(AUDIO_CONTINUAR))


func aoFocarCampo() -> void:
	# se o mouse já está em cima do campo, a fala já tocou ao passar o mouse
	if campoNome.get_global_rect().has_point(get_global_mouse_position()):
		return
	Narrador.falar(AUDIO_NOME)


func aoApertarComecar() -> void:
	var nomeDigitado: String = campoNome.text.strip_edges()
	if nomeDigitado.is_empty():
		campoNome.grab_focus()   # também narra "Digite seu nome" para lembrar o aluno
		return
	Aluno.nome = nomeDigitado
	print(Aluno.nome)
	Navegacao.irPara("res://cenas/telaTutorial.tscn")
