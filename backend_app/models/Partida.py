from database.db import db  # era: from database import db

class Partida(db.Model):
    __tablename__ = "partidas"

    id = db.Column(db.Integer, primary_key=True)
    data = db.Column(db.Date, nullable=False)
    time_casa_id = db.Column(db.Integer, db.ForeignKey("times.id"), nullable=False)       # era foreing_key errado
    time_visitante_id = db.Column(db.Integer, db.ForeignKey("times.id"), nullable=False)  # era foreing_key errado
    placar_casa = db.Column(db.Integer, nullable=False)
    placar_visitante = db.Column(db.Integer, nullable=False)   # era db.integer (minúsculo)
