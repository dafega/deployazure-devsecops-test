import sqlite3

def get_db_connection(db_path):
    """Create connection"""
    conn = sqlite3.connect(db_path)
    conn.row_factory = sqlite3.Row
    return conn

def init_db(db_path):
    conn = get_db_connection(db_path)
    cursor = conn.cursor()
    cursor.execute('''
        CREATE TABLE IF NOT EXISTS bicycles (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            propietario TEXT NOT NULL,
            marca TEXT NOT NULL,
            tamano TEXT NOT NULL,
            color TEXT NOT NULL
        )
    ''')
    conn.commit()
    conn.close()