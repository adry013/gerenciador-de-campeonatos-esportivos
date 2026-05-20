from database.db import db

class Jogador(db.Model):
    __tablename__ = "jogadores"

    id = db.Column(db.Integer, primary_key=True)
    nome = db.Column(db.String(100), nullable=False)
    posicao = db.Column(db.String(100), nullable=False)       # era db.column (minúsculo)
    time_id = db.Column(db.Integer, db.ForeignKey("times.id"), nullable=False)  # era id.Column e foreing_key errado
