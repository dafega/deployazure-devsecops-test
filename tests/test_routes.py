import pytest
import os
import tempfile
from app import create_app
from app.database import init_db

@pytest.fixture
def app():
    """Crea una aplicación Flask para testing"""
    # Crear base de datos temporal
    db_fd, db_path = tempfile.mkstemp(suffix='.db')
    
    app = create_app()
    app.config['DATABASE'] = db_path
    app.config['TESTING'] = True
    app.config['SECRET_KEY'] = 'test-secret-key'
    
    # Inicializar base de datos
    init_db(db_path)
    
    with app.app_context():
        yield app
    
    # Limpiar
    os.close(db_fd)
    os.unlink(db_path)

@pytest.fixture
def client(app):
    """Cliente de prueba para hacer requests"""
    return app.test_client()

class TestBicyclesAPI:
    """Tests para las operaciones CRUD del inventario de bicicletas"""
    
    def test_create_bicycle(self, client):
        """Test crear una nueva bicicleta"""
        response = client.post('/api/bicycles', 
                              json={
                                  'propietario': 'Daniel',
                                  'marca': 'Trek',
                                  'tamano': 'M',
                                  'color': 'Rojo'
                              })
        assert response.status_code == 201
        data = response.get_json()
        assert data['propietario'] == 'Daniel'
        assert data['marca'] == 'Trek'
        assert data['tamano'] == 'M'
        assert data['color'] == 'Rojo'
        assert 'id' in data
    
    def test_create_bicycle_without_propietario(self, client):
        """Test crear bicicleta sin propietario debe fallar"""
        response = client.post('/api/bicycles', 
                              json={'marca': 'Giant', 'tamano': 'L', 'color': 'Azul'})
        assert response.status_code == 400
    
    def test_create_bicycle_without_marca(self, client):
        """Test crear bicicleta sin marca debe fallar"""
        response = client.post('/api/bicycles', 
                              json={'propietario': 'Elena', 'tamano': 'S', 'color': 'Verde'})
        assert response.status_code == 400
    
    def test_create_bicycle_without_tamano(self, client):
        """Test crear bicicleta sin tamaño debe fallar"""
        response = client.post('/api/bicycles', 
                              json={'propietario': 'Marta', 'marca': 'Scott', 'color': 'Negro'})
        assert response.status_code == 400
    
    def test_create_bicycle_without_color(self, client):
        """Test crear bicicleta sin color debe fallar"""
        response = client.post('/api/bicycles', 
                              json={'propietario': 'Pablo', 'marca': 'Specialized', 'tamano': 'M'})
        assert response.status_code == 400
    
    def test_get_all_bicycles(self, client):
        """Test obtener todas las bicicletas"""
        # Crear algunas bicicletas
        client.post('/api/bicycles', 
                   json={'propietario': 'Daniel', 'marca': 'Trek', 'tamano': 'M', 'color': 'Rojo'})
        client.post('/api/bicycles', 
                   json={'propietario': 'Elena', 'marca': 'Giant', 'tamano': 'S', 'color': 'Azul'})
        
        response = client.get('/api/bicycles')
        assert response.status_code == 200
        data = response.get_json()
        assert data['count'] == 2
        assert len(data['bicycles']) == 2
    
    def test_get_bicycle_by_id(self, client):
        """Test obtener una bicicleta por ID"""
        # Crear una bicicleta
        create_response = client.post('/api/bicycles', 
                                     json={'propietario': 'Daniel', 'marca': 'Trek', 'tamano': 'M', 'color': 'Rojo'})
        bicycle_id = create_response.get_json()['id']
        
        # Obtener la bicicleta
        response = client.get(f'/api/bicycles/{bicycle_id}')
        assert response.status_code == 200
        data = response.get_json()
        assert data['propietario'] == 'Daniel'
        assert data['marca'] == 'Trek'
        assert data['id'] == bicycle_id
    
    def test_get_nonexistent_bicycle(self, client):
        """Test obtener una bicicleta que no existe"""
        response = client.get('/api/bicycles/999')
        assert response.status_code == 404
    
    def test_update_bicycle(self, client):
        """Test actualizar una bicicleta"""
        # Crear una bicicleta
        create_response = client.post('/api/bicycles', 
                                     json={'propietario': 'Daniel', 'marca': 'Trek', 'tamano': 'M', 'color': 'Rojo'})
        bicycle_id = create_response.get_json()['id']
        
        # Actualizar la bicicleta
        response = client.put(f'/api/bicycles/{bicycle_id}',
                             json={'color': 'Azul', 'tamano': 'L'})
        assert response.status_code == 200
        data = response.get_json()
        assert data['color'] == 'Azul'
        assert data['tamano'] == 'L'
        assert data['propietario'] == 'Daniel'  # No cambió
        assert data['marca'] == 'Trek'  # No cambió
    
    def test_update_bicycle_all_fields(self, client):
        """Test actualizar todos los campos de una bicicleta"""
        create_response = client.post('/api/bicycles', 
                                     json={'propietario': 'Daniel', 'marca': 'Trek', 'tamano': 'M', 'color': 'Rojo'})
        bicycle_id = create_response.get_json()['id']
        
        response = client.put(f'/api/bicycles/{bicycle_id}',
                             json={
                                 'propietario': 'Elena',
                                 'marca': 'Giant',
                                 'tamano': 'S',
                                 'color': 'Verde'
                             })
        assert response.status_code == 200
        data = response.get_json()
        assert data['propietario'] == 'Elena'
        assert data['marca'] == 'Giant'
        assert data['tamano'] == 'S'
        assert data['color'] == 'Verde'
    
    def test_update_nonexistent_bicycle(self, client):
        """Test actualizar una bicicleta que no existe"""
        response = client.put('/api/bicycles/999', json={'color': 'Rojo'})
        assert response.status_code == 404
    
    def test_delete_bicycle(self, client):
        """Test eliminar una bicicleta"""
        # Crear una bicicleta
        create_response = client.post('/api/bicycles', 
                                     json={'propietario': 'Daniel', 'marca': 'Trek', 'tamano': 'M', 'color': 'Rojo'})
        bicycle_id = create_response.get_json()['id']
        
        # Eliminar la bicicleta
        response = client.delete(f'/api/bicycles/{bicycle_id}')
        assert response.status_code == 200
        
        # Verificar que fue eliminada
        get_response = client.get(f'/api/bicycles/{bicycle_id}')
        assert get_response.status_code == 404
    
    def test_delete_nonexistent_bicycle(self, client):
        """Test eliminar una bicicleta que no existe"""
        response = client.delete('/api/bicycles/999')
        assert response.status_code == 404
    
    def test_health_check(self, client):
        """Test del endpoint de salud"""
        response = client.get('/api/bicycles/health')
        assert response.status_code == 200
        data = response.get_json()
        assert data['status'] == 'healthy'
        assert data['service'] == 'bicycles-inventory-api'
