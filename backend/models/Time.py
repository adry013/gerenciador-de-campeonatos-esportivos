from database.db import db

class Time(db.Model):
    __tablename__ = "times"

    id = db.Column(db.Integer, primary_key=True)
    nome = db.Column(db.String(100), nullable=False)
    cidade = db.Column(db.String(100), nullable=False)
    jogadores = db.relationship("Jogador", backref="time", cascade="all, delete")  # era "jogador" (minúsculo)
