from app.database import get_db_connection
from flask import current_app

class Bicycle:
    def __init__(self, id=None, propietario=None, marca=None, tamano=None, color=None):
        self.id = id
        self.propietario = propietario
        self.marca = marca
        self.tamano = tamano
        self.color = color
    
    def to_dict(self):
        return {
            'id': self.id,
            'propietario': self.propietario,
            'marca': self.marca,
            'tamano': self.tamano,
            'color': self.color
        }
    
    @staticmethod
    def create(propietario, marca, tamano, color):
        """Create bike"""
        conn = get_db_connection(current_app.config['DATABASE'])
        cursor = conn.cursor()
        cursor.execute(
            'INSERT INTO bicycles (propietario, marca, tamano, color) VALUES (?, ?, ?, ?)',
            (propietario, marca, tamano, color)
        )
        conn.commit()
        bicycle_id = cursor.lastrowid
        conn.close()
        return Bicycle.get_by_id(bicycle_id)
    
    @staticmethod
    def get_all():
        """Get all bikes"""
        conn = get_db_connection(current_app.config['DATABASE'])
        cursor = conn.cursor()
        cursor.execute('SELECT * FROM bicycles ORDER BY id ASC')
        rows = cursor.fetchall()
        conn.close()
        return [Bicycle(**dict(row)).to_dict() for row in rows]
    
    @staticmethod
    def get_by_id(bicycle_id):
        """get bike for id"""
        conn = get_db_connection(current_app.config['DATABASE'])
        cursor = conn.cursor()
        cursor.execute('SELECT * FROM bicycles WHERE id = ?', (bicycle_id,))
        row = cursor.fetchone()
        conn.close()
        if row:
            return Bicycle(**dict(row))
        return None
    
    @staticmethod
    def update(bicycle_id, propietario=None, marca=None, tamano=None, color=None):
        """update bikes"""
        conn = get_db_connection(current_app.config['DATABASE'])
        cursor = conn.cursor()
        
        updates = []
        params = []
        
        if propietario is not None:
            updates.append('propietario = ?')
            params.append(propietario)
        if marca is not None:
            updates.append('marca = ?')
            params.append(marca)
        if tamano is not None:
            updates.append('tamano = ?')
            params.append(tamano)
        if color is not None:
            updates.append('color = ?')
            params.append(color)
        
        if updates:
            params.append(bicycle_id)
            query = f'UPDATE bicycles SET {", ".join(updates)} WHERE id = ?'
            cursor.execute(query, params)
            conn.commit()
        
        conn.close()
        return Bicycle.get_by_id(bicycle_id)
    
    @staticmethod
    def delete(bicycle_id):
        """delete bikes with id"""
        conn = get_db_connection(current_app.config['DATABASE'])
        cursor = conn.cursor()
        cursor.execute('DELETE FROM bicycles WHERE id = ?', (bicycle_id,))
        conn.commit()
        deleted = cursor.rowcount > 0
        conn.close()
        return deleted