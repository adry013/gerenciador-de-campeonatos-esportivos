from flask import Blueprint, request, jsonify
from database.db import db
from models.Jogador import Jogador
from models.Time import Time

jogador_bp = Blueprint("jogador_bp", __name__)

@jogador_bp.route("/jogadores", methods=["GET"])
def listar_jogadores():
    jogadores = Jogador.query.all()
    return jsonify([
        {
            "id": j.id,
            "nome": j.nome,
            "posicao": j.posicao,
            "time_id": j.time_id
        } for j in jogadores
    ])


@jogador_bp.route("/jogadores/<int:id>", methods=["GET"])
def buscar_jogador(id):
    jogador = Jogador.query.get(id)
    if not jogador:
        return jsonify({"erro": "Jogador não encontrado"}), 404

    return jsonify({
        "id": jogador.id,
        "nome": jogador.nome,
        "posicao": jogador.posicao,
        "time_id": jogador.time_id
    })


@jogador_bp.route("/jogadores", methods=["POST"])
def criar_jogador():
    dados = request.json

    time = Time.query.get(dados["time_id"])
    if not time:
        return jsonify({"erro": "Time não encontrado"}), 404

    novo_jogador = Jogador(
        nome=dados["nome"],
        posicao=dados["posicao"],
        time_id=dados["time_id"]
    )

    db.session.add(novo_jogador)
    db.session.commit()

    return jsonify({"mensagem": "Jogador criado com sucesso"}), 201


@jogador_bp.route("/jogadores/<int:id>", methods=["PUT"])
def atualizar_jogador(id):
    jogador = Jogador.query.get(id)
    if not jogador:
        return jsonify({"erro": "Jogador não encontrado"}), 404

    dados = request.json

    jogador.nome = dados.get("nome", jogador.nome)
    jogador.posicao = dados.get("posicao", jogador.posicao)

    if "time_id" in dados:
        time = Time.query.get(dados["time_id"])
        if not time:
            return jsonify({"erro": "Time não encontrado"}), 404
        jogador.time_id = dados["time_id"]

    db.session.commit()
    return jsonify({"mensagem": "Jogador atualizado com sucesso"})


@jogador_bp.route("/jogadores/<int:id>", methods=["DELETE"])
def deletar_jogador(id):
    jogador = Jogador.query.get(id)
    if not jogador:
        return jsonify({"erro": "Jogador não encontrado"}), 404

    db.session.delete(jogador)
    db.session.commit()

    return jsonify({"mensagem": "Jogador deletado com sucesso"})