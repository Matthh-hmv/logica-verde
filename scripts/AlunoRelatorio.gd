extends Node

var fase: int = 1
var nome: String = ""
var tempoFase1: float = 0.0
var cronometroAtivo: bool = false
var errosFase1: int = 0
var emailProfessora: String = ""

var tempoFase2: float = 0.0
var erroConta: int = 0
var erroObjeto: int = 0

# true depois que o relatório do aluno atual foi gravado no .csv (evita gravar duas vezes)
var relatorioRegistrado: bool = false

func _process(delta: float) -> void:
	if cronometroAtivo and fase == 1:
		tempoFase1 += delta
	elif cronometroAtivo and fase == 2:
		tempoFase2 += delta

func pausar_tempo() -> void:
	cronometroAtivo = false

func continuar_tempo() -> void:
	cronometroAtivo = true

func formatar_tempo(segundos_totais: float) -> String:
	var minutos: int = floori(segundos_totais / 60.0)
	var segundos: int = int(segundos_totais) % 60
	return "%02d:%02d" % [minutos, segundos]

func pontosFase1 () -> int:
	var segundos = Aluno.tempoFase1
	var erros = Aluno.errosFase1
	var pontos: int = 100
	if segundos > 300:
		pontos -= 40
	elif segundos > 270:
		pontos -= 30
	elif segundos > 240:
		pontos -= 20
	elif segundos > 210:
		pontos -= 10

	if erros > 30:
		pontos -= 40
	elif erros >= 25:
		pontos -= 30
	elif erros >= 20:
		pontos -= 20
	elif erros >= 15:
		pontos -= 20


	return pontos

func pontosFase2() -> int:
	var pontos: int = 100
	var segundos = tempoFase2
	if segundos > 500:
		pontos -= 40
	elif segundos > 470:
		pontos -= 30
	elif segundos > 440:
		pontos -= 20
	elif segundos > 410:
		pontos -= 10

	# ">=" (e não "==") para quem errar mais do que o máximo de cada faixa também perder pontos
	if Aluno.erroConta >= 6:
		pontos -= 30
	elif Aluno.erroConta >= 4:
		pontos -= 20
	elif Aluno.erroConta >= 2:
		pontos -= 10

	if Aluno.erroObjeto >= 2:
		pontos -= 20
	elif Aluno.erroObjeto == 1:
		pontos -= 10

	return pontos


func resetar() -> void:
	fase = 1
	cronometroAtivo = false
	nome = ""
	tempoFase1 = 0.0
	errosFase1 = 0
	tempoFase2 = 0.0
	erroConta = 0
	erroObjeto = 0
	relatorioRegistrado = false
