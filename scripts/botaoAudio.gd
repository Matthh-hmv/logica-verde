extends TextureButton
var nivelAtual: int = 1
const PASTA := "res://Assets/Áudios/Fases/"

# dica de cada nível da fase 1
const DICAS := {
	1: PASTA + "Fase 1.1 (Manuela)/Nível 1- ache os pares! Vire duas cartas cada vez e encontre.wav",
	2: PASTA + "Fase 1.2 (Nickole)/Nivel 2 alcance os pares.wav",
	3: PASTA + "Fase 1.3 (Matheus)/Nível 3, selecione a carta dos objetos.wav"
}


@export_file("*.wav") var audioPersonalizado: String = ""

func _ready() -> void:
	pressed.connect(onAjudaPressed)

func onAjudaPressed() -> void:
	if Aluno.fase == 2:
		Narrador.falar("res://Assets/Áudios/Fases/Fase 2 (Kamilla)/geral/Chegue até a escola pelo melhor caminho.wav")
	elif DICAS.has(Narrador.nivelAtual):
		Narrador.falar(DICAS[Narrador.nivelAtual])
