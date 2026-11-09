extends Node

var historico: Array[String] = []

func irPara(cena: String) -> void:
	historico.append(get_tree().current_scene.scene_file_path)
	get_tree().change_scene_to_file(cena)

func voltar() -> void:
	if historico.is_empty():
		return
	get_tree().change_scene_to_file(historico.pop_back())
