import os
from flask import Blueprint, request, jsonify
from app.models import Bicycle

config_bp = Blueprint('config', __name__, url_prefix='/api')


@config_bp.route('/secret', methods=['GET'])
def get_secret():
    """Devuelve MY_SECRET desde variable de entorno (requerido por reglas del proyecto)."""
    return jsonify({'MY_SECRET': os.environ.get('MY_SECRET', '')}), 200


bicycles_bp = Blueprint('bicycles', __name__, url_prefix='/api/bicycles')

@bicycles_bp.route('', methods=['GET'])
def get_bicycles():
    """Route get bike"""
    try:
        bicycles = Bicycle.get_all()
        return jsonify({'bicycles': bicycles, 'count': len(bicycles)}), 200
    except Exception as e:
        return jsonify({'error': str(e)}), 500

@bicycles_bp.route('/<int:bicycle_id>', methods=['GET'])
def get_bicycle(bicycle_id):
    """Get bike for id"""
    try:
        bicycle = Bicycle.get_by_id(bicycle_id)
        if bicycle:
            return jsonify(bicycle.to_dict()), 200
        return jsonify({'error': 'Bicicleta no encontrada'}), 404
    except Exception as e:
        return jsonify({'error': str(e)}), 500

@bicycles_bp.route('', methods=['POST'])
def create_bicycle():
    """create new bike"""
    try:
        data = request.get_json()
        if not data:
            return jsonify({'error': 'No se proporcionaron datos'}), 400
        
        propietario = data.get('propietario', '').strip()
        marca = data.get('marca', '').strip()
        tamano = data.get('tamano', '').strip()
        color = data.get('color', '').strip()
        
        if not propietario:
            return jsonify({'error': 'El propietario es requerido'}), 400
        if not marca:
            return jsonify({'error': 'La marca es requerida'}), 400
        if not tamano:
            return jsonify({'error': 'El tamaño es requerido'}), 400
        if not color:
            return jsonify({'error': 'El color es requerido'}), 400
        
        bicycle = Bicycle.create(propietario, marca, tamano, color)
        return jsonify(bicycle.to_dict()), 201
    except Exception as e:
        return jsonify({'error': str(e)}), 500

@bicycles_bp.route('/<int:bicycle_id>', methods=['PUT'])
def update_bicycle(bicycle_id):
    """update bikes"""
    try:
        bicycle = Bicycle.get_by_id(bicycle_id)
        if not bicycle:
            return jsonify({'error': 'Bicicleta no encontrada'}), 404
        
        data = request.get_json()
        if not data:
            return jsonify({'error': 'No se proporcionaron datos'}), 400
        
        updated_bicycle = Bicycle.update(
            bicycle_id,
            propietario=data.get('propietario'),
            marca=data.get('marca'),
            tamano=data.get('tamano'),
            color=data.get('color')
        )
        
        return jsonify(updated_bicycle.to_dict()), 200
    except Exception as e:
        return jsonify({'error': str(e)}), 500

@bicycles_bp.route('/<int:bicycle_id>', methods=['DELETE'])
def delete_bicycle(bicycle_id):
    """delete bikes"""
    try:
        deleted = Bicycle.delete(bicycle_id)
        if deleted:
            return jsonify({'message': 'Bicicleta eliminada exitosamente'}), 200
        return jsonify({'error': 'Bicicleta no encontrada'}), 404
    except Exception as e:
        return jsonify({'error': str(e)}), 500

@bicycles_bp.route('/health', methods=['GET'])
def health_check():
    """healthy endpoint route"""
    return jsonify({'status': 'healthy', 'service': 'bicycles-inventory-api'}), 200