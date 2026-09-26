# Clasificador de mensajes de commit con IA local

Proyecto del SENA que despliega localmente un servicio de inferencia
de IA que clasifica mensajes de commit en las categorias:
feat, fix, docs, test, chore, refactor.

## Integrantes

- Danna Sanchez (dannacharitsanchez56@gmail.com)

## Perfil de hardware

- Windows + WSL2 con Ubuntu 24.04
- 4 GB de RAM asignados a WSL
- x86_64, sin GPU dedicada

## Arquitectura

- Ollama -> motor de inferencia local (gemma3:270m)
- FastAPI -> API REST del clasificador
- PostgreSQL -> registro de inferencias
- Docker -> contenedores de API y BD
- GitHub Actions -> integracion continua

## Requisitos

- Ubuntu 24.04 (o WSL2)
- Docker Engine 27+
- Docker Compose v2
- Python 3.12
- Ollama 0.34+
- Git

## Instalacion

    git clone git@github.com:dannacharitsanchez56-crypto/clasificador-commits-equipo.git
    cd clasificador-commits-equipo
    cp .env.example .env
    ollama pull gemma3:270m
    docker compose up -d --build

## Verificacion

    docker compose ps
    curl http://localhost:8000/health

## Endpoints

| Metodo | Ruta          | Descripcion                    |
|--------|---------------|--------------------------------|
| GET    | /health       | Estado de la API y la BD       |
| POST   | /clasificar   | Clasifica un mensaje           |
| GET    | /inferencias  | Lista las inferencias          |

Documentacion interactiva: http://localhost:8000/docs

## Ejemplo de uso

    curl -X POST http://localhost:8000/clasificar \
      -H "Content-Type: application/json" \
      -d '{"mensaje":"agrega nueva funcion de login"}'

## Scripts

- setup.sh: instala herramientas basicas
- diagnostico.sh: verifica versiones

## Pruebas

    ./tests/pruebas_funcionales.sh
    ./tests/pruebas_permisos.sh
    ./tests/pruebas_infra.sh

## Estado del proyecto

- [x] AA1 - Preparacion del entorno
- [x] AA2 - Backend de produccion
- [x] AA3 - Contenerizacion e integracion continua
- [x] AA4 - Plan de pruebas
- [x] AA5 - Operacion, documentacion y entrega

## Documentacion

- docs/arquitectura.md
- docs/politica_seguridad.md
- docs/ficha_modelo.md
- docs/plan_pruebas.md
- docs/informe_pruebas.md
- docs/manual_tecnico.md
- docs/informe_tecnico.md

## Video demostracion

[Pendiente de subir]

## Repositorio

https://github.com/dannacharitsanchez56-crypto/clasificador-commits-equipo

## Licencia

MIT# clasificador-commits-equipo
Clasificador de mensajes de commit con IA local (Ollama + FastAPI + PostgreSQL)
