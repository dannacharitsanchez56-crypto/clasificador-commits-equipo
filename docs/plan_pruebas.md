# Plan de pruebas

## Objetivo

Verificar el correcto funcionamiento del clasificador de mensajes de commit
en sus dimensiones funcional, de seguridad, de infraestructura y de rendimiento.

## Entorno de pruebas

- Sistema: Windows + WSL2 Ubuntu 24.04
- Docker Engine + Docker Compose
- PostgreSQL 16 en contenedor
- API FastAPI en contenedor
- Ollama con modelo gemma3:270m en el host

## Matriz de pruebas

| ID   | Nombre              | Tipo            | Descripción                                | Resultado esperado                          |
|------|---------------------|-----------------|--------------------------------------------|---------------------------------------------|
| P-01 | Health              | Funcional       | GET /health                                | estado=ok, base_datos=ok                    |
| P-02 | Clasificación       | Funcional       | POST /clasificar con mensaje válido        | tipo en {feat,fix,docs,test,chore,refactor} |
| P-03 | Validación          | Validación      | POST /clasificar sin campo mensaje         | Error HTTP 422                              |
| P-04 | Permisos mínimos    | Seguridad       | DELETE y DROP como usuario app_ia          | ERROR: permission denied                    |
| P-05 | Conectividad        | Infraestructura | La API conecta a PostgreSQL                | 200 OK en /health                           |
| P-06 | Disponibilidad      | Infraestructura | docker compose ps                          | api-ia y db-ia en estado Up (healthy)       |
| P-07 | Persistencia        | BD              | Insertar y consultar inferencias           | Datos visibles en GET /inferencias          |
| P-08 | Carga               | Rendimiento     | 10 usuarios virtuales durante 1m30s con k6 | p95 menor a 500 ms, 0% errores              |
| P-09 | Latencia del modelo | Rendimiento     | 10 inferencias secuenciales con Ollama     | promedio, mediana y p95 documentados        |

## Criterios de aceptación

- P-01 a P-07: 100% de éxito.
- P-08: latencia p95 menor a 500 ms y 0% de errores HTTP.
- P-09: latencia documentada y comparable con P-08.
