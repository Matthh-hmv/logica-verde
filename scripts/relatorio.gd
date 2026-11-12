class_name RelatorioCSV
extends RefCounted

# Mantém UM arquivo .csv com todos os alunos: cada vez que um aluno termina, as linhas dele
# são acrescentadas no fim (o cabeçalho só é escrito quando o arquivo ainda não existe).
# Uso:
#   var caminho := RelatorioCSV.registrar(Aluno.nome, Aluno.tempoFase1, Aluno.errosFase1,
#           Aluno.tempoFase2, Aluno.erroConta, Aluno.erroObjeto)
# Retorna o caminho do arquivo ("user://relatorios/relatorio_geral.csv") ou "" se falhar.
# Para o envio por email: RelatorioCSV.ARQUIVO (user://) ou RelatorioCSV.caminhoReal() (do sistema).

const PASTA := "user://relatorios/"
const ARQUIVO := PASTA + "relatorio_geral.csv"
const SEPARADOR := ";"   # ";" abre direto no Excel em português. Troque por "," se preferir
const QUEBRA := "\r\n"

const CABECALHO := ["Aluno", "Data e hora", "Fase", "Tempo", "Erros",
		"Comentário sobre o tempo", "Comentário sobre os erros"]


static func registrar(nome: String, tempoFase1: float, errosFase1: int,
		tempoFase2: float, erroConta: int, erroObjeto: int) -> String:
	var data := _dataHora()
	var linhas: Array[String] = []

	linhas.append(_linha([nome, data, "Fase 1 - Jogo da memória",
			_formataTempo(tempoFase1), errosFase1,
			_tempoFase1(tempoFase1), _errosFase1(errosFase1)]))

	linhas.append(_linha([nome, data, "Fase 2 - Chegue até a escola",
			_formataTempo(tempoFase2),
			"%d em contas e %d em objetos" % [erroConta, erroObjeto],
			_tempoFase2(tempoFase2), _errosFase2(erroConta, erroObjeto)]))

	if not DirAccess.dir_exists_absolute(PASTA):
		DirAccess.make_dir_recursive_absolute(PASTA)

	var existe := FileAccess.file_exists(ARQUIVO)
	var arquivo := FileAccess.open(ARQUIVO, FileAccess.READ_WRITE if existe else FileAccess.WRITE)
	if arquivo == null:
		push_error("Relatório: não foi possível abrir %s (erro %d)" % [ARQUIVO, FileAccess.get_open_error()])
		return ""

	if arquivo.get_length() == 0:
		arquivo.store_buffer(PackedByteArray([0xEF, 0xBB, 0xBF]))   # BOM UTF-8: o Excel lê os acentos certo
		arquivo.store_string(_linha(CABECALHO) + QUEBRA)
	else:
		arquivo.seek_end()

	arquivo.store_string(QUEBRA.join(linhas) + QUEBRA)
	arquivo.close()
	return ARQUIVO


# Caminho do arquivo no sistema (útil para anexar no email)
static func caminhoReal() -> String:
	return ProjectSettings.globalize_path(ARQUIVO)


# ---------- Comentários (mesmas faixas da pontuação) ----------

static func _tempoFase1(s: float) -> String:
	if s > 300:
		return "Aluno levou bastante tempo para concluir o jogo (mais de 5 minutos). Pode precisar de mais tempo, apoio e incentivo para manter a atenção na atividade."
	elif s > 270:
		return "Aluno levou mais tempo que o esperado para concluir o jogo. Vale acompanhar e incentivar a atenção durante a atividade."
	elif s > 240:
		return "Aluno concluiu o jogo em tempo um pouco acima do esperado."
	elif s > 210:
		return "Aluno concluiu o jogo em bom tempo."
	return "Aluno concluiu o jogo rapidamente, em ótimo tempo."


static func _errosFase1(e: int) -> String:
	if e > 30:
		return "Aluno teve muita dificuldade em identificar os pares e errou com muita frequência. Recomenda-se acompanhamento individual e repetir a atividade."
	elif e >= 25:
		return "Aluno teve bastante dificuldade em identificar os pares. Vale reforçar a atividade com apoio."
	elif e >= 20:
		return "Aluno teve dificuldade moderada em identificar os pares, com vários erros ao longo do jogo."
	elif e >= 15:
		return "Aluno teve alguma dificuldade em identificar os pares, com alguns erros."
	return "Aluno identificou os pares com facilidade, com poucos erros."


static func _tempoFase2(s: float) -> String:
	if s > 500:
		return "Aluno levou bastante tempo para chegar até a escola (mais de 8 minutos). Pode precisar de mais tempo e apoio para resolver os desafios do percurso."
	elif s > 470:
		return "Aluno levou mais tempo que o esperado para chegar até a escola."
	elif s > 440:
		return "Aluno chegou até a escola em tempo um pouco acima do esperado."
	elif s > 410:
		return "Aluno chegou até a escola em bom tempo."
	return "Aluno chegou até a escola rapidamente, em ótimo tempo."


static func _errosFase2(erroConta: int, erroObjeto: int) -> String:
	var contas := "Aluno resolveu as contas com facilidade."
	if erroConta >= 6:
		contas = "Aluno teve muita dificuldade nas contas de soma e subtração, com muitos erros."
	elif erroConta >= 4:
		contas = "Aluno teve bastante dificuldade nas contas de soma e subtração."
	elif erroConta >= 2:
		contas = "Aluno teve alguma dificuldade em algumas contas."

	var objetos := "Identificou o objeto mais sustentável sem erros."
	if erroObjeto >= 2:
		objetos = "Teve dificuldade em identificar o objeto mais sustentável."
	elif erroObjeto == 1:
		objetos = "Errou apenas uma vez ao escolher o objeto mais sustentável."

	return contas + " " + objetos


# ---------- Ajudantes do CSV ----------

static func _linha(campos: Array) -> String:
	var partes := PackedStringArray()
	for c in campos:
		partes.append(_campo(c))
	return SEPARADOR.join(partes)


# Sempre entre aspas (aspas internas dobradas). O apóstrofo evita que o Excel execute
# como fórmula um nome digitado pelo aluno que comece com = + - @
static func _campo(valor) -> String:
	var texto := str(valor)
	if texto != "" and texto[0] in ["=", "+", "-", "@", "\t", "\r"]:
		texto = "'" + texto
	return "\"" + texto.replace("\"", "\"\"") + "\""


# "4 min 05 s" (em texto, para o Excel não converter em horário)
static func _formataTempo(segundos: float) -> String:
	var total := int(round(segundos))
	var minutos := floori(total / 60.0)
	var seg := total % 60
	if minutos == 0:
		return "%d s" % seg
	return "%d min %02d s" % [minutos, seg]


static func _dataHora() -> String:
	var d := Time.get_datetime_dict_from_system()
	return "%02d/%02d/%04d %02d:%02d" % [d.day, d.month, d.year, d.hour, d.minute]
