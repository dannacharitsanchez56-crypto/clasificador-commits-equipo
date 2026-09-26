# Ficha de caracterización del modelo de IA

## 1. Información general

| Campo | Valor |
|-------|-------|
| Nombre del modelo | gemma3:270m |
| Familia | Gemma 3 |
| Desarrollador | Google DeepMind |
| Versión de Ollama | 0.34.4 |
| Tamaño en disco | 291 MB |
| ID del modelo | e7d36fb2c3b3 |
| Fecha de descarga | 2026-09-26 |
| Tipo de licencia | Gemma Terms of Use |

## 2. Perfil de hardware del equipo

| Componente | Especificación |
|-----------|----------------|
| Sistema operativo | Windows + WSL2 Ubuntu 24.04 |
| Arquitectura | x86_64 |
| RAM | 4 GB |
| CPU | Intel/AMD (escribe el modelo real) |
| GPU | No disponible (inferencia en CPU) |

## 3. Uso previsto en el proyecto

El modelo `gemma3:270m` será utilizado como motor de inferencia local
para clasificar mensajes de commit en las categorías:

- feat
- fix
- docs
- test
- chore
- refactor

Se accede mediante la API REST local de Ollama en:
`http://localhost:11434/api/generate`

## 4. Prueba de funcionamiento

Comando ejecutado:

```bash
curl http://localhost:11434/api/generate -d '{"model":"gemma3:270m","prompt":"Responde solo con una palabra: hola","stream":false}'
