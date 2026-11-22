extends TextureButton
var nivelAtual: int = 1
const PASTA := "res://assets/audios/fases/"

# dica de cada nível da fase 1
const DICAS := {
	1: PASTA + "fase1Nivel1/instrucao.wav",
	2: PASTA + "fase1Nivel2/instrucao.wav",
	3: PASTA + "fase1Nivel3/instrucao.wav"
}


@export_file("*.wav") var audioPersonalizado: String = ""

func _ready() -> void:
	pressed.connect(onAjudaPressed)

func onAjudaPressed() -> void:
	if Aluno.fase == 2:
		Narrador.falar("res://assets/audios/fases/fase2/geral/instrucao.wav")
	elif DICAS.has(Narrador.nivelAtual):
		Narrador.falar(DICAS[Narrador.nivelAtual])
