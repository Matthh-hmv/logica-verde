extends Node

var historico: Array[String] = []
var _trocando := false

func irPara(cena: String) -> void:
	if _trocando:
		return
	var atual := get_tree().current_scene
	if atual == null:
		return
	_trocando = true
	historico.append(atual.scene_file_path)
	get_tree().change_scene_to_file(cena)
	await get_tree().process_frame
	await get_tree().process_frame
	_trocando = false

func voltar() -> void:
	if _trocando or historico.is_empty():
		return
	_trocando = true
	get_tree().change_scene_to_file(historico.pop_back())
	await get_tree().process_frame
	await get_tree().process_frame
	_trocando = false
