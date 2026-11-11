extends Node2D

@onready var botaoComecar: TextureButton = $BotaoComecar
@onready var botaoRelatorio: TextureButton = $BotaoRelatorio
@onready var botaoSobre: TextureButton = $BotaoSobre
@onready var botaoSair: TextureButton = $BotaoSair

# Troque pelos caminhos dos seus áudios
const AUDIOS := {
	"comecar": "res://Assets/Áudios/Tela inicial/Começar.wav",
	"relatorio": "res://Assets/Áudios/Tela inicial/Relatório.wav",
	"sobre": "res://Assets/Áudios/Tela inicial/sobre.wav",
	"sair": "res://Assets/Áudios/Tela inicial/sair.wav",
}


func _ready() -> void:
	botaoComecar.pressed.connect(onComecarPressed)
	botaoRelatorio.pressed.connect(onRelatorioPressed)
	botaoSobre.pressed.connect(onSobrePressed)
	botaoSair.pressed.connect(onSairPressed)
	
	# foco inicial ANTES de conectar a narração, para não falar ao abrir
	botaoComecar.grab_focus()

	_conectaNarracao(botaoComecar, AUDIOS["comecar"])
	_conectaNarracao(botaoRelatorio, AUDIOS["relatorio"])
	_conectaNarracao(botaoSobre, AUDIOS["sobre"])
	_conectaNarracao(botaoSair, AUDIOS["sair"])

	# foco inicial para navegação por teclado (também narra o primeiro botão)
	botaoComecar.grab_focus()


# Narra ao passar o mouse e ao receber foco pelo teclado
func _conectaNarracao(botao: TextureButton, audio: String) -> void:
	botao.mouse_entered.connect(Narrador.falar.bind(audio))
	botao.focus_entered.connect(Narrador.falar.bind(audio))


func onComecarPressed() -> void:
	Navegacao.irPara("res://cenas/telaNome.tscn")

func onRelatorioPressed() -> void:
	pass

func onSobrePressed() -> void:
	Navegacao.irPara("res://cenas/telaSobre.tscn")

func onSairPressed() -> void:
	get_tree().quit()
