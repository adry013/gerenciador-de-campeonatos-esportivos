from flask import Blueprint, request, jsonify
from database.db import db
from models.Partida import Partida
from models.Time import Time
from datetime import datetime

partida_bp = Blueprint("partida_bp", __name__)

@partida_bp.route("/partidas", methods=["GET"])
def listar_partidas():
    partidas = Partida.query.all()
    return jsonify([
        {
            "id": p.id,
            "data": str(p.data),
            "time_casa_id": p.time_casa_id,
            "time_visitante_id": p.time_visitante_id,
            "placar_casa": p.placar_casa,
            "placar_visitante": p.placar_visitante
        } for p in partidas
    ])


@partida_bp.route("/partidas/<int:id>", methods=["GET"])
def buscar_partida(id):
    partida = Partida.query.get(id)
    if not partida:
        return jsonify({"erro": "Partida não encontrada"}), 404

    return jsonify({
        "id": partida.id,
        "data": str(partida.data),
        "time_casa_id": partida.time_casa_id,
        "time_visitante_id": partida.time_visitante_id,
        "placar_casa": partida.placar_casa,
        "placar_visitante": partida.placar_visitante
    })


@partida_bp.route("/partidas", methods=["POST"])
def criar_partida():
    dados = request.json

    time_casa = Time.query.get(dados["time_casa_id"])
    time_visitante = Time.query.get(dados["time_visitante_id"])

    if not time_casa or not time_visitante:
        return jsonify({"erro": "Time casa ou visitante não encontrado"}), 404

    data_convertida = datetime.strptime(dados["data"], "%Y-%m-%d").date()

    nova_partida = Partida(
        data=data_convertida,
        time_casa_id=dados["time_casa_id"],
        time_visitante_id=dados["time_visitante_id"],
        placar_casa=dados["placar_casa"],
        placar_visitante=dados["placar_visitante"]
    )

    db.session.add(nova_partida)
    db.session.commit()

    return jsonify({"mensagem": "Partida criada com sucesso"}), 201


@partida_bp.route("/partidas/<int:id>", methods=["PUT"])
def atualizar_partida(id):
    partida = Partida.query.get(id)
    if not partida:
        return jsonify({"erro": "Partida não encontrada"}), 404

    dados = request.json

    if "data" in dados:
        partida.data = datetime.strptime(dados["data"], "%Y-%m-%d").date()

    if "time_casa_id" in dados:
        time_casa = Time.query.get(dados["time_casa_id"])
        if not time_casa:
            return jsonify({"erro": "Time casa não encontrado"}), 404
        partida.time_casa_id = dados["time_casa_id"]

    if "time_visitante_id" in dados:
        time_visitante = Time.query.get(dados["time_visitante_id"])
        if not time_visitante:
            return jsonify({"erro": "Time visitante não encontrado"}), 404
        partida.time_visitante_id = dados["time_visitante_id"]

    partida.placar_casa = dados.get("placar_casa", partida.placar_casa)
    partida.placar_visitante = dados.get("placar_visitante", partida.placar_visitante)

    db.session.commit()
    return jsonify({"mensagem": "Partida atualizada com sucesso"})


@partida_bp.route("/partidas/<int:id>", methods=["DELETE"])
def deletar_partida(id):
    partida = Partida.query.get(id)
    if not partida:
        return jsonify({"erro": "Partida não encontrada"}), 404

    db.session.delete(partida)
    db.session.commit()

    return jsonify({"mensagem": "Partida deletada com sucesso"})