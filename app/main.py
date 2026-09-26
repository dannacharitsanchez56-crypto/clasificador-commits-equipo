"""
Clasificador de mensajes de commit con IA local.
Backend FastAPI que expone los endpoints /health, /clasificar e /inferencias.
"""
import os
import time

import psycopg2
import requests
from dotenv import load_dotenv
from fastapi import FastAPI, HTTPException
from pydantic import BaseModel

# Cargar variables de entorno desde .env
load_dotenv()

DB_HOST = os.getenv("DB_HOST", "localhost")
DB_PORT = os.getenv("DB_PORT", "5432")
DB_NAME = os.getenv("DB_NAME", "iadb")
DB_USER = os.getenv("DB_USER", "app_ia")
DB_PASSWORD = os.getenv("DB_PASSWORD", "")
OLLAMA_URL = os.getenv("OLLAMA_URL", "http://localhost:11434/api/generate")
MOTOR_POR_DEFECTO = os.getenv("MOTOR_POR_DEFECTO", "eco")

app = FastAPI(
    title="Clasificador de mensajes de commit",
    description="Servicio de inferencia local para clasificar commits con IA",
    version="1.0.0",
)


# -------------------- MODELOS --------------------
class CommitInput(BaseModel):
    mensaje: str


class ClasificacionOutput(BaseModel):
    motor: str
    tipo: str
    latencia_ms: int


# -------------------- UTILIDADES --------------------
def get_db_connection():
    """Crea una conexión a PostgreSQL."""
    return psycopg2.connect(
        host=DB_HOST,
        port=DB_PORT,
        dbname=DB_NAME,
        user=DB_USER,
        password=DB_PASSWORD,
    )


def clasificar_eco(mensaje: str) -> str:
    """Clasificador simple por palabras clave (motor de respaldo)."""
    msg = mensaje.lower()
    if any(k in msg for k in ["add", "agrega", "feature", "nueva"]):
        return "feat"
    if any(k in msg for k in ["fix", "arregla", "corrige", "bug"]):
        return "fix"
    if any(k in msg for k in ["doc", "readme", "comentario"]):
        return "docs"
    if any(k in msg for k in ["test", "prueba"]):
        return "test"
    if any(k in msg for k in ["refactor", "reestructura"]):
        return "refactor"
    return "chore"


def clasificar_ollama(mensaje: str) -> str:
    """Clasifica usando el modelo local en Ollama."""
    prompt = (
        "Clasifica el siguiente mensaje de commit en UNA sola palabra "
        "entre estas opciones: feat, fix, docs, test, chore, refactor. "
        f"Mensaje: '{mensaje}'. Responde solo con la palabra."
    )
    try:
        r = requests.post(
            OLLAMA_URL,
            json={"model": "gemma3:270m", "prompt": prompt, "stream": False},
            timeout=60,
        )
        r.raise_for_status()
        respuesta = r.json().get("response", "").strip().lower()
        # Limpiar respuesta: tomar solo la primera palabra válida
        for tipo in ["feat", "fix", "docs", "test", "chore", "refactor"]:
            if tipo in respuesta:
                return tipo
        return "chore"
    except Exception as e:
        print(f"Error con Ollama: {e}. Usando motor eco.")
        return clasificar_eco(mensaje)


# -------------------- ENDPOINTS --------------------
@app.get("/health")
def health():
    """Verifica el estado de la API y la conexión a PostgreSQL."""
    try:
        conn = get_db_connection()
        conn.close()
        return {"estado": "ok", "base_datos": "ok"}
    except Exception as e:
        return {"estado": "ok", "base_datos": f"error: {e}"}


@app.post("/clasificar", response_model=ClasificacionOutput)
def clasificar(data: CommitInput):
    """Clasifica un mensaje de commit y guarda la inferencia en la BD."""
    inicio = time.time()

    if MOTOR_POR_DEFECTO == "ollama":
        tipo = clasificar_ollama(data.mensaje)
    else:
        tipo = clasificar_eco(data.mensaje)

    latencia_ms = int((time.time() - inicio) * 1000)

    # Guardar en la base de datos
    try:
        conn = get_db_connection()
        cur = conn.cursor()
        cur.execute(
            """INSERT INTO inferencias (motor, modelo, entrada, salida, latencia_ms)
               VALUES (%s, %s, %s, %s, %s)""",
            (MOTOR_POR_DEFECTO, "gemma3:270m", data.mensaje, tipo, latencia_ms),
        )
        conn.commit()
        cur.close()
        conn.close()
    except Exception as e:
        print(f"Error guardando en BD: {e}")
        raise HTTPException(status_code=500, detail=f"Error BD: {e}")

    return ClasificacionOutput(
        motor=MOTOR_POR_DEFECTO, tipo=tipo, latencia_ms=latencia_ms
    )


@app.get("/inferencias")
def listar_inferencias(limit: int = 10):
    """Devuelve las últimas inferencias registradas."""
    try:
        conn = get_db_connection()
        cur = conn.cursor()
        cur.execute(
            """SELECT id, fecha, motor, modelo, entrada, salida, latencia_ms
               FROM inferencias ORDER BY id DESC LIMIT %s""",
            (limit,),
        )
        filas = cur.fetchall()
        cur.close()
        conn.close()

        return [
            {
                "id": f[0],
                "fecha": f[1].isoformat() if f[1] else None,
                "motor": f[2],
                "modelo": f[3],
                "entrada": f[4],
                "salida": f[5],
                "latencia_ms": f[6],
            }
            for f in filas
        ]
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Error BD: {e}")
