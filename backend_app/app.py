from flask import Flask
from config import config
from database.db import db

from routes.Time_routes import time_bp
from routes.Jogador_routes import jogador_bp
from routes.Partida_routes import partida_bp

def create_app():
    app = Flask(__name__)
    app.config.from_object(config)

    db.init_app(app)

    app.register_blueprint(time_bp)
    app.register_blueprint(jogador_bp)
    app.register_blueprint(partida_bp)

    with app.app_context():
        db.create_all()

    return app

app = create_app()

if __name__ == "__main__":
    app.run(debug=True)