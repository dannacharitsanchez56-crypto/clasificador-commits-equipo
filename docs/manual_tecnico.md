# Manual tecnico

## 1. Descripcion general

El proyecto implementa un clasificador de mensajes de commit que usa
inteligencia artificial local para categorizar cada mensaje en uno de
estos tipos: feat, fix, docs, test, chore o refactor.

## 2. Arquitectura

- Cliente -> envia peticiones HTTP
- API FastAPI (puerto 8000) -> expone los endpoints
- PostgreSQL (puerto 5432) -> guarda las inferencias
- Ollama (puerto 11434) -> ejecuta el modelo gemma3:270m
- Docker Compose -> orquesta los contenedores

## 3. Requisitos

- Ubuntu 24.04 (o WSL2 en Windows)
- Docker Engine 27+
- Docker Compose v2
- Python 3.12
- Ollama 0.34+
- Git

## 4. Instalacion

    git clone git@github.com:dannacharitsanchez56-crypto/clasificador-commits-equipo.git
    cd clasificador-commits-equipo
    cp .env.example .env
    docker compose up -d --build

## 5. Endpoints

| Metodo | Ruta          | Descripcion                    |
|--------|---------------|--------------------------------|
| GET    | /health       | Estado de la API y la BD       |
| POST   | /clasificar   | Clasifica un mensaje           |
| GET    | /inferencias  | Lista las inferencias          |

## 6. Modelo de datos

Tabla inferencias:

| Campo       | Tipo         | Descripcion                     |
|-------------|--------------|---------------------------------|
| id          | SERIAL PK    | Identificador unico             |
| fecha       | TIMESTAMP    | Fecha y hora de la inferencia   |
| motor       | VARCHAR(50)  | Motor usado                     |
| modelo      | VARCHAR(100) | Nombre del modelo               |
| entrada     | TEXT         | Mensaje de commit original      |
| salida      | TEXT         | Tipo clasificado                |
| latencia_ms | INTEGER      | Duracion en milisegundos        |

## 7. Seguridad

- El rol app_ia solo tiene permisos SELECT e INSERT.
- No puede DELETE, UPDATE ni DROP.
- Credenciales en .env (no versionado).
- Contenedor corre como appuser (sin privilegios).

## 8. Respaldo y restauracion

Respaldo:

    docker compose exec -T db pg_dump -U postgres iadb > backups/respaldo.sql

Restauracion:

    cat backups/respaldo.sql | docker compose exec -T db psql -U postgres -d iadb

## 9. Decisiones de diseno

1. Ollama para inferencia local (privacidad y sin costos).
2. gemma3:270m por su tamano reducido (291 MB).
3. Motor eco para pruebas rapidas y fallback.
4. Docker Compose para despliegue con un comando.
5. Rol de BD con privilegios minimos.
6. Multi-stage build para imagen mas pequena.

## 10. Limitaciones conocidas

- Cold start del modelo tarda ~2.4 s la primera vez.
- Baja precision en mensajes ambiguos.
- Sin autenticacion en endpoints.
- Un solo worker de uvicorn.
- Credenciales en texto plano en .env.

## 11. Solucion de problemas

Si api-ia no arranca:

    docker compose logs api

Si error de conexion a BD:

    docker compose ps

Si el puerto 8000 esta ocupado:

    sudo lsof -i :8000

Si Ollama no responde:

    ollama serve &
