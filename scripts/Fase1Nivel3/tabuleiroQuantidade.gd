extends Node2D
class_name TabuleiroQuantidade

@export_range(0, 2) var variante: int = 0   
@export var linhas: int = 3

const CARTA_OBJETO := preload("res://cenas/fase 1.3/carta_objetos.tscn")
const CARTA_NUMERO := preload("res://cenas/fase 1.3/carta_numeros.tscn")
const POPUP := preload("res://cenas/pop_up.tscn")
const PASTA_AUDIO := "res://Assets/Áudios/Fases/Fase 1.3 (Matheus)/"
const AUDIO_INSTRUCAO := PASTA_AUDIO + "Nível 3, selecione a carta dos objetos.wav"

var popup: popUpBase
@onready var anim: AnimationPlayer = $AnimationPlayer


# Centro de cada carta, em pixels da imagem original do tabuleiro (1384x1000)
const X_OBJETO := 480.0
const X_NUMERO := 1175.0
const Y_LINHAS := [200.0, 500.0, 800.0]

@onready var tabuleiro: TextureRect = $CanvasLayer/TextureRect

var selecao: Array[CartaSelecionavel] = []
var lockInput: bool = false
var acertos: int = 0

var comparaCarta: Timer
var comparaDelay: float = 0.6
	
func _ready() -> void:
	if variante == 0:
		variante = randi_range(1, 2)
	popup = POPUP.instantiate()
	popup.visible = false
	$CanvasLayer.add_child(popup)
	criaTabuleiro()
	setupTimer()


func criaTabuleiro() -> void:
	var idsObjetos := _sorteiaIds()
	var idsNumeros := _embaralhaDiferente(idsObjetos)

	# fator entre o tamanho exibido do tabuleiro e o da imagem original
	var fator: float = tabuleiro.size.x / tabuleiro.texture.get_size().x

	for i in range(linhas):
		var y: float = Y_LINHAS[i]

		var objeto: CartaObjeto = CARTA_OBJETO.instantiate()
		tabuleiro.add_child(objeto)
		objeto.setTextura(idsObjetos[i], variante)
		objeto.scale = Vector2.ONE * fator
		objeto.position = Vector2(X_OBJETO, y) * fator
		objeto.clicked.connect(cartaClicada)

		var numero: CartaNumero = CARTA_NUMERO.instantiate()
		tabuleiro.add_child(numero)
		numero.setTextura(idsNumeros[i])
		numero.scale = Vector2.ONE * fator
		numero.position = Vector2(X_NUMERO, y) * fator
		numero.clicked.connect(cartaClicada)


# Sorteia 'linhas' ids diferentes entre 0 e 4
func _sorteiaIds() -> Array[int]:
	var todos: Array[int] = [0, 1, 2, 3, 4]
	todos.shuffle()
	var sorteados: Array[int] = []
	for i in range(linhas):
		sorteados.append(todos[i])
	return sorteados


# Embaralha os números evitando que fiquem na mesma ordem dos objetos
func _embaralhaDiferente(ids: Array[int]) -> Array[int]:
	var copia: Array[int] = ids.duplicate()
	if linhas < 2:
		return copia
	while copia == ids:
		copia.shuffle()
	return copia


# Clique na carta

func cartaClicada(carta: CartaSelecionavel) -> void:
	if lockInput or carta.isLocked:
		return

	# clicar de novo na carta escolhida desfaz a escolha
	if carta.isSelected:
		carta.deselecionar()
		selecao.erase(carta)
		return

	# só uma carta de cada tipo por vez: escolher outra do mesmo tipo troca a seleção
	for outra in selecao:
		if outra.get_script() == carta.get_script():
			outra.deselecionar()
			selecao.erase(outra)
			break

	carta.selecionar(acertos)
	selecao.append(carta)

	if selecao.size() == 2:
		lockInput = true
		comparaCarta.start()


func setupTimer() -> void:
	comparaCarta = Timer.new()
	comparaCarta.wait_time = comparaDelay
	comparaCarta.one_shot = true
	add_child(comparaCarta)
	comparaCarta.timeout.connect(comparaTimeout)

func comparaTimeout() -> void:
	if selecao.size() < 2:
		lockInput = false
		selecao.clear()
		return

	var a := selecao[0]
	var b := selecao[1]
	selecao.clear()

	# espera terminar de narrar a segunda carta
	await Narrador.esperarTerminar()

	if a.combina(b):
		a.par()
		b.par()
		acertos += 1
		if acertos == linhas:
			terminouNivel()
	else:
		a.deselecionar()
		b.deselecionar()
		var popup: popUpBase = POPUP.instantiate()
		$CanvasLayer.add_child(popup)
		await popup.erroPar(3)
		popup.queue_free()

	lockInput = false


func terminouNivel() -> void:
	await popup.finalizaMemoria(3)
	# get_tree().change_scene_to_file("res://cenas/...tscn")
	pass
