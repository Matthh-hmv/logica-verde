class_name Casa
extends Marker2D

enum Tipo { NORMAL, AZUL, VERMELHA }

@export var tipo: Tipo = Tipo.NORMAL
@export var eh_escola := false
@export_multiline var instrucao_seguinte := ""   # texto do painel ao completar esta casa

@export_group("Vizinhas")
@export var cima: NodePath
@export var baixo: NodePath
@export var esquerda: NodePath
@export var direita: NodePath

const OPOSTAS := {"cima": "baixo", "baixo": "cima", "esquerda": "direita", "direita": "esquerda"}
var vizinhas := {}
var completada := false
var desafio: Dictionary = {}   # preenchido no sorteio pelo tabuleiro

func _ready() -> void:
	add_to_group("casas")
	for dir in OPOSTAS:
		var caminho: NodePath = get(dir)
		if not caminho.is_empty():
			var outra := get_node(caminho) as Casa
			vizinhas[dir] = outra
			outra.vizinhas[OPOSTAS[dir]] = self

func completar(textura_estrela: Texture2D) -> void:
	completada = true
	$Estrela.texture = textura_estrela
