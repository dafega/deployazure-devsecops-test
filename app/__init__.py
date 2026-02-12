import os
from flask import Flask
from app.database import init_db

def create_app():
    app = Flask(__name__)
    app.config['SECRET_KEY'] = os.environ.get('SECRET_KEY', 'inventorykey')
    app.config['DATABASE'] = os.environ.get('DATABASE', 'inventory.db')
    # Inicializar base de datos
    init_db(app.config['DATABASE'])
    # Registrar blueprints
    from app.routes import config_bp, bicycles_bp
    app.register_blueprint(config_bp)
    app.register_blueprint(bicycles_bp)
    return app


app = create_app()