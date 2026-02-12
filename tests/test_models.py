import pytest
import os
import tempfile
from app import create_app
from app.database import init_db
from app.models import Bicycle

@pytest.fixture
def db():
    """Crea una base de datos temporal para testing"""
    db_fd, db_path = tempfile.mkstemp(suffix='.db')
    init_db(db_path)
    
    app = create_app()
    app.config['DATABASE'] = db_path
    
    with app.app_context():
        yield db_path
    
    # Limpiar
    os.close(db_fd)
    os.unlink(db_path)

class TestBicycleModel:
    """Tests para el modelo Bicycle"""
    
    def test_create_bicycle(self, db):
        """Test crear una bicicleta en la base de datos"""
        app = create_app()
        app.config['DATABASE'] = db
        
        with app.app_context():
            bicycle = Bicycle.create('Daniel', 'Trek', 'M', 'Rojo')
            assert bicycle.id is not None
            assert bicycle.propietario == 'Daniel'
            assert bicycle.marca == 'Trek'
            assert bicycle.tamano == 'M'
            assert bicycle.color == 'Rojo'
    
    def test_get_all_bicycles(self, db):
        """Test obtener todas las bicicletas"""
        app = create_app()
        app.config['DATABASE'] = db
        
        with app.app_context():
            Bicycle.create('Daniel', 'Trek', 'M', 'Rojo')
            Bicycle.create('Elena', 'Giant', 'S', 'Azul')
            Bicycle.create('Marta', 'Scott', 'L', 'Verde')
            
            bicycles = Bicycle.get_all()
            assert len(bicycles) == 3
    
    def test_get_bicycle_by_id(self, db):
        """Test obtener una bicicleta por ID"""
        app = create_app()
        app.config['DATABASE'] = db
        
        with app.app_context():
            created_bicycle = Bicycle.create('Daniel', 'Trek', 'M', 'Rojo')
            bicycle_id = created_bicycle.id
            
            retrieved_bicycle = Bicycle.get_by_id(bicycle_id)
            assert retrieved_bicycle is not None
            assert retrieved_bicycle.propietario == 'Daniel'
            assert retrieved_bicycle.marca == 'Trek'
            assert retrieved_bicycle.id == bicycle_id
    
    def test_get_nonexistent_bicycle(self, db):
        """Test obtener una bicicleta que no existe"""
        app = create_app()
        app.config['DATABASE'] = db
        
        with app.app_context():
            bicycle = Bicycle.get_by_id(999)
            assert bicycle is None
    
    def test_update_bicycle(self, db):
        """Test actualizar una bicicleta"""
        app = create_app()
        app.config['DATABASE'] = db
        
        with app.app_context():
            bicycle = Bicycle.create('Daniel', 'Trek', 'M', 'Rojo')
            bicycle_id = bicycle.id
            
            updated_bicycle = Bicycle.update(bicycle_id, color='Azul', tamano='L')
            assert updated_bicycle.color == 'Azul'
            assert updated_bicycle.tamano == 'L'
            assert updated_bicycle.propietario == 'Daniel'  # No cambió
            assert updated_bicycle.marca == 'Trek'  # No cambió
    
    def test_update_bicycle_all_fields(self, db):
        """Test actualizar todos los campos de una bicicleta"""
        app = create_app()
        app.config['DATABASE'] = db
        
        with app.app_context():
            bicycle = Bicycle.create('Daniel', 'Trek', 'M', 'Rojo')
            bicycle_id = bicycle.id
            
            updated_bicycle = Bicycle.update(
                bicycle_id, 
                propietario='Elena',
                marca='Giant',
                tamano='S',
                color='Verde'
            )
            assert updated_bicycle.propietario == 'Elena'
            assert updated_bicycle.marca == 'Giant'
            assert updated_bicycle.tamano == 'S'
            assert updated_bicycle.color == 'Verde'
    
    def test_delete_bicycle(self, db):
        """Test eliminar una bicicleta"""
        app = create_app()
        app.config['DATABASE'] = db
        
        with app.app_context():
            bicycle = Bicycle.create('Daniel', 'Trek', 'M', 'Rojo')
            bicycle_id = bicycle.id
            
            deleted = Bicycle.delete(bicycle_id)
            assert deleted is True
            
            # Verificar que fue eliminada
            retrieved_bicycle = Bicycle.get_by_id(bicycle_id)
            assert retrieved_bicycle is None
    
    def test_bicycle_to_dict(self, db):
        """Test conversión de bicicleta a diccionario"""
        app = create_app()
        app.config['DATABASE'] = db
        
        with app.app_context():
            bicycle = Bicycle.create('Daniel', 'Trek', 'M', 'Rojo')
            bicycle_dict = bicycle.to_dict()
            
            assert isinstance(bicycle_dict, dict)
            assert 'id' in bicycle_dict
            assert 'propietario' in bicycle_dict
            assert 'marca' in bicycle_dict
            assert 'tamano' in bicycle_dict
            assert 'color' in bicycle_dict
            assert bicycle_dict['propietario'] == 'Daniel'
            assert bicycle_dict['marca'] == 'Trek'
            assert bicycle_dict['tamano'] == 'M'
            assert bicycle_dict['color'] == 'Rojo'
