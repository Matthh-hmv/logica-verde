extends TextureButton

@onready var botao_relatorio: TextureButton = $"."
@onready var http_request: HTTPRequest = $HTTPRequest

const RESEND_API_KEY = "re_YoLMHL1F_Mk9HYhx5i7w14hgXSaU8gRoN"

func _ready() -> void:
	botao_relatorio.pressed.connect(_on_botao_relatorio_pressed)
	http_request.request_completed.connect(_on_resposta_api)

func _on_botao_relatorio_pressed() -> void:
	botao_relatorio.disabled = true 
	
	var nome_jogador = "Joãozinho"
	var pontuacao_final = 150 
	var email_prof = "renatacschreiner97@gmail.com" 
	
	var csv_falso = "Fase,Tempo(s),Estrelas,Comentario\nFase 1,110,3,Rapido\nFase 2,210,2,Demorou um pouco\n"
	var csv_base64 = Marshalls.utf8_to_base64(csv_falso)
	
	# Monta o pacote EXATAMENTE como o Resend exige
	var payload = {
		"from": "Seu Jogo <onboarding@resend.dev>",
		"to": [email_prof],
		"subject": "Relatório de Desempenho - " + nome_jogador,
		"html": "<h1>Relatório de " + nome_jogador + "</h1><p>Pontuação total: <strong>" + str(pontuacao_final) + "</strong></p><p>Segue em anexo o relatório detalhado.</p>",
		"attachments": [
			{
				"filename": "desempenho_jogador.csv",
				"content": csv_base64
			}
		]
	}
	
	var json_enviar = JSON.stringify(payload)
	
	var headers = [
		"Content-Type: application/json",
		"Authorization: Bearer " + RESEND_API_KEY
	]
	
	var url = "https://api.resend.com/emails"
	
	# Dispara a requisição direto pro Resend
	http_request.request(url, headers, HTTPClient.METHOD_POST, json_enviar)

func _on_resposta_api(result: int, response_code: int, headers: PackedStringArray, body: PackedByteArray) -> void:
	botao_relatorio.disabled = false 
	

	if response_code >= 200 and response_code < 300:
		print("Sucesso! E-mail enviado direto pelo Godot. Resposta: ", body.get_string_from_utf8())
	else:
		print("Ops, deu erro. Código HTTP: ", response_code)
		if body.size() > 0:
			print("Detalhes: ", body.get_string_from_utf8())
