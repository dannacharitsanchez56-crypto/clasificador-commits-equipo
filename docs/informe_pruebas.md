## P-09: Caracterización de latencia del modelo

### Metodología

Se enviaron 10 inferencias secuenciales al endpoint `/api/generate`
de Ollama usando el modelo `gemma3:270m`. Se ejecutaron dos rondas:
la primera para medir el cold start, la segunda con el modelo ya
cargado en memoria.

### Ronda 1 (cold start)

| # | Latencia (ms) |
|---|---------------|
| 1 | 2369 |
| 2 | 243 |
| 3 | 398 |
| 4 | 260 |
| 5 | 310 |
| 6 | 230 |
| 7 | 260 |
| 8 | 408 |
| 9 | 190 |
| 10 | 221 |

- **Promedio:** 488 ms
- **Mediana:** 260 ms
- **p95:** 2369 ms

### Ronda 2 (modelo en memoria)

| # | Latencia (ms) |
|---|---------------|
| 1 | 225 |
| 2 | 266 |
| 3 | 174 |
| 4 | 202 |
| 5 | 181 |
| 6 | 214 |
| 7 | 199 |
| 8 | 242 |
| 9 | 205 |
| 10 | 216 |

- **Promedio:** 212 ms
- **Mediana:** 209 ms
- **p95:** 266 ms

### Análisis

La primera inferencia tras arrancar el modelo presenta una latencia
de ~2.4 s debido a la carga del modelo en memoria (cold start).
Una vez cargado, las inferencias se mantienen estables en el rango
de 170-270 ms.

En producción se recomienda mantener el modelo "caliente"
(precargado) para evitar el impacto del cold start en el primer
usuario.

### Conclusión

El modelo `gemma3:270m` ofrece un rendimiento adecuado para
clasificación interactiva de mensajes de commit, con latencias
de ~210 ms en régimen estable.

## P-08: Prueba de carga con k6

### Metodología

Se ejecutó un script de k6 con 10 usuarios virtuales durante 1 minuto
30 segundos, cada uno enviando un POST /clasificar con mensaje
aleatorio y esperando 1 segundo entre peticiones.

### Resultados

| Metrica               | Valor     | Umbral    | Estado |
|-----------------------|-----------|-----------|--------|
| Iteraciones totales   | 880       | -         | OK     |
| Checks exitosos       | 1760/1760 | 100%      | OK     |
| http_req_failed       | 0.00%     | menor 1%  | OK     |
| http_req_duration avg | 32.62 ms  | -         | OK     |
| http_req_duration med | 25.27 ms  | -         | OK     |
| http_req_duration p95 | 50.75 ms  | menor 500 | OK     |
| http_req_duration max | 326.87 ms | -         | OK     |

### Comparacion P-08 vs P-09

| Metrica  | P-08 eco | P-09 Ollama | Diferencia |
|----------|----------|-------------|------------|
| p95      | 50.75 ms | 266 ms      | 5.2x       |
| Mediana  | 25.27 ms | 209 ms      | 8.3x       |
| Promedio | 32.62 ms | 212 ms      | 6.5x       |

### Conclusion

El motor eco responde en unos 25 ms usando reglas simples. El motor
Ollama tarda unos 210 ms porque ejecuta una red neuronal. La diferencia
es esperada y justifica tener ambos motores.

### Mejoras propuestas

1. Mantener Ollama precargado para evitar el cold start.
2. Agregar cache de clasificaciones frecuentes.
3. Usar el motor eco como fallback si Ollama tarda mas de 1 segundo.
