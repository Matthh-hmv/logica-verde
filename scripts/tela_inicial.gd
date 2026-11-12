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

var _popup: PopupRelatorio = null


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


# Narra ao passar o mouse e ao receber foco pelo teclado
func _conectaNarracao(botao: TextureButton, audio: String) -> void:
	botao.mouse_entered.connect(Narrador.falar.bind(audio))
	botao.focus_entered.connect(Narrador.falar.bind(audio))


func onComecarPressed() -> void:
	Navegacao.irPara("res://cenas/telaNome.tscn")

func onRelatorioPressed() -> void:
	_abrePopup(PopupRelatorio.Modo.RELATORIO)

func onSobrePressed() -> void:
	Navegacao.irPara("res://cenas/telaSobre.tscn")

func onSairPressed() -> void:
	# sem relatório gravado (ninguém terminou o jogo), não há nada para enviar: sai direto
	if not PopupRelatorio.temRelatorio():
		get_tree().quit()
		return
	_abrePopup(PopupRelatorio.Modo.SAIR)


func _abrePopup(modo: PopupRelatorio.Modo) -> void:
	if _popup != null:
		return
	_popup = PopupRelatorio.new()
	add_child(_popup)
	_popup.fechado.connect(func() -> void: _popup = null)
	_popup.abrir(modo)
