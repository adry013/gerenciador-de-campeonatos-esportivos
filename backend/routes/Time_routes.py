from flask import Blueprint, request, jsonify
from database.db import db
from models.Time import Time

time_bp = Blueprint("time_bp", __name__)

@time_bp.route("/times", methods=["GET"])
def listar_times():
    times = Time.query.all()
    return jsonify([{"id": t.id, "nome": t.nome, "cidade": t.cidade} for t in times])


@time_bp.route("/times/<int:id>", methods=["GET"])
def buscar_time(id):
    time_obj = Time.query.get(id)   # era: time = time.query.get(id) → variável "time" sobrescrevia a classe Time
    if not time_obj:
        return jsonify({"erro": "Time não encontrado"}), 404

    return jsonify({"id": time_obj.id, "nome": time_obj.nome, "cidade": time_obj.cidade})


@time_bp.route("/times", methods=["POST"])
def criar_time():
    dados = request.json

    novo_time = Time(
        nome=dados["nome"],
        cidade=dados["cidade"]
    )

    db.session.add(novo_time)
    db.session.commit()

    return jsonify({"mensagem": "Time criado com sucesso"}), 201


@time_bp.route("/times/<int:id>", methods=["PUT"])
def atualizar_time(id):
    time_obj = Time.query.get(id)   # mesmo problema de shadowing
    if not time_obj:
        return jsonify({"erro": "Time não encontrado"}), 404

    dados = request.json
    time_obj.nome = dados.get("nome", time_obj.nome)
    time_obj.cidade = dados.get("cidade", time_obj.cidade)

    db.session.commit()
    return jsonify({"mensagem": "Time atualizado com sucesso"})


@time_bp.route("/times/<int:id>", methods=["DELETE"])
def deletar_time(id):
    time_obj = Time.query.get(id)   # mesmo problema de shadowing
    if not time_obj:
        return jsonify({"erro": "Time não encontrado"}), 404

    db.session.delete(time_obj)
    db.session.commit()

    return jsonify({"mensagem": "Time deletado com sucesso"})
