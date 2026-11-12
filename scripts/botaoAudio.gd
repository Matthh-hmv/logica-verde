extends TextureButton
var nivelAtual: int = 1
const PASTA := "res://Assets/Áudios/Fases/"

# dica de cada nível da fase 1
const DICAS := {
	1: PASTA + "Fase 1.1 (Manuela)/Nível 1- ache os pares! Vire duas cartas cada vez e encontre.wav",
	2: PASTA + "Fase 1.2 (Nickole)/Nivel 2 alcance os pares.wav",
	3: PASTA + "Fase 1.3 (Matheus)/Nível 3, selecione a carta dos objetos.wav"
}

# Outras fases: escolha o .wav no Inspector (tem prioridade)
@export_file("*.wav") var audioPersonalizado: String = ""

@onready var botaoAjuda: TextureButton = $BotaoAjuda

func _ready() -> void:
	pressed.connect(onAjudaPressed)

func onAjudaPressed() -> void:
	if audioPersonalizado != "":
		Narrador.falar(audioPersonalizado)
	elif DICAS.has(Narrador.nivelAtual):
		Narrador.falar(DICAS[Narrador.nivelAtual])
