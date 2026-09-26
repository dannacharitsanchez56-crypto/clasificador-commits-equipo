# Informe tecnico

## 1. Resumen ejecutivo

Se desarrollo un clasificador de mensajes de commit basado en IA local.
El sistema clasifica cada mensaje en feat, fix, docs, test, chore o
refactor usando el modelo gemma3:270m a traves de Ollama.

## 2. Objetivo

Construir un servicio de inferencia local que automatice la clasificacion
de mensajes de commit, aplicando buenas practicas de DevOps: contenerizacion,
integracion continua, pruebas automatizadas y documentacion.

## 3. Arquitectura

- API FastAPI en contenedor api-ia (puerto 8000)
- PostgreSQL 16 en contenedor db-ia (puerto 5432)
- Ollama en el host (puerto 11434)
- Volumen pgdata para persistencia
- Pipeline CI en GitHub Actions

## 4. Resultados de pruebas

| ID   | Prueba              | Resultado |
|------|---------------------|-----------|
| P-01 | Health              | PASS      |
| P-02 | Clasificacion       | PASS      |
| P-03 | Validacion          | PASS      |
| P-04 | Permisos minimos    | PASS      |
| P-05 | Conectividad        | PASS      |
| P-06 | Disponibilidad      | PASS      |
| P-07 | Persistencia        | PASS      |
| P-08 | Carga (k6)          | PASS      |
| P-09 | Latencia del modelo | PASS      |

## 5. Analisis de rendimiento

P-08 (motor eco, k6 con 10 VUs por 1m30s):
- p95: 50.75 ms
- 0% de errores
- 880 iteraciones

P-09 (motor Ollama, 10 inferencias):
- p95: 266 ms (regimen estable)
- cold start: ~2400 ms
- mediana: 209 ms

Conclusion: el motor eco es ~8x mas rapido que Ollama.

## 6. Conclusiones

- La contenerizacion facilita el despliegue reproducible.
- El uso de IA local elimina costos de API y mantiene privacidad.
- Los privilegios minimos de BD previenen danos accidentales.
- El pipeline de CI detecta errores antes del merge.

## 7. Recomendaciones

1. Agregar autenticacion JWT a los endpoints.
2. Migrar credenciales a un gestor de secretos.
3. Agregar un proxy inverso con HTTPS.
4. Evaluar modelos mayores para mejor precision.
5. Implementar cache de clasificaciones frecuentes.
6. Agregar monitoreo con Prometheus + Grafana.
