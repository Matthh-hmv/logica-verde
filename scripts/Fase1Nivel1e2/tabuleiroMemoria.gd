extends Node2D
class_name TabuleiroMemoria
@export var nivel: int = 1

const POPUP := preload("res://cenas/pop_up.tscn")
const CARTACENA:= preload("res://cenas/fase 1.1 e 1.2/carta_base.tscn")

var colunas:int = 5 #colunas das cartas
var linhas:int = 2 #linhas das cartas 
var espacamentoCarta: = Vector2(200, 235) #espaçamento entre as cartas

var cartaSelecionada:Array[CartaBase] = []
var lockInput:bool = false
var acertos:int = 0

var comparaCarta:Timer
var comparaDelay:float = 0.6

func _ready() -> void:
	Aluno.fase = 1
	Aluno.continuar_tempo()
	Narrador.nivelAtual = nivel
	criaTabuleiro()
	setupTimer()

func criaTabuleiro() -> void:

	var pares:Array[int] = criaPares() #!Pode passar como parametro o nivel
	if pares.is_empty():
		return

	var index:= 0

	for y in range(linhas):
		for x in range(colunas):
			if index >= pares.size():
				return

			var carta: CartaBase = CARTACENA.instantiate()
			add_child(carta)
			carta.setTextura(pares[index], nivel)
			index += 1
			carta.scale = Vector2(0.2, 0.2)
			carta.position = Vector2(
				560 + x * espacamentoCarta.x,
				420 + y * espacamentoCarta.y
			)
			carta.clicked.connect(cartaClicada)

#Cria os pares de cartas

func criaPares() -> Array[int]:
	var totalCartas:= colunas * linhas

	if totalCartas % 2 != 0:
			push_error("Total de cartas não é par")
			return []

	var pares:Array[int] = []

	for i in range(totalCartas/2):
		pares.append(i)
		pares.append(i)

	pares.shuffle()
	return pares

#Clicou na carta
func cartaClicada(carta: CartaBase) -> void:
	if lockInput:
		return

	if carta.isFlipped or carta.isLocked:
		return

	carta.aberta()
	cartaSelecionada.append(carta)

	if cartaSelecionada.size() == 2:
		lockInput = true
		comparaCarta.start()

func setupTimer() -> void:
	comparaCarta = Timer.new()
	comparaCarta.wait_time = comparaDelay
	comparaCarta.one_shot = true
	add_child(comparaCarta)
	comparaCarta.timeout.connect(comparaTimeout)


func comparaTimeout() -> void:
	if cartaSelecionada.size() < 2:
		lockInput = false
		cartaSelecionada.clear()
		return

	var a:= cartaSelecionada[0]
	var b:= cartaSelecionada[1]

	# espera terminar de narrar o nome da carta antes de seguir
	await Narrador.esperarTerminar()

	var popup: popUpBase = POPUP.instantiate()
	add_child(popup)
	if a.id == b.id:
		a.par()
		b.par()
		acertos += 1
		Aluno.pausar_tempo()   # o tempo não conta enquanto o pop-up está aberto
		await popup.mostraPopUp(a.id, nivel)
		if acertos == 5:
			# última dupla: o tempo continua pausado até a próxima cena começar
			await popup.finalizaMemoria(nivel)
			if nivel == 1:
				Navegacao.irPara("res://cenas/fase 1.1 e 1.2/fase_1_2.tscn")
			else:
				Navegacao.irPara("res://cenas/fase 1.3/fase_1_3.tscn")
		else:
			Aluno.continuar_tempo()
	else:
		a.fechada()
		b.fechada()
		Aluno.errosFase1 += 1   # erro = dupla errada (antes estava contando no acerto)
		Aluno.pausar_tempo()
		await popup.erroPar(nivel)
		Aluno.continuar_tempo()
	popup.queue_free()
	cartaSelecionada.clear()
	lockInput = false
