class_name Casa
extends Marker2D

@export var cima: Casa
@export var baixo: Casa
@export var esquerda: Casa
@export var direita: Casa
@export var eh_escola := false

func _ready() -> void:
	# Basta ligar numa direção no Inspector; a volta é automática
	if cima: cima.baixo = self
	if baixo: baixo.cima = self
	if esquerda: esquerda.direita = self
	if direita: direita.esquerda = self
