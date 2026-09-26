# Diagrama de arquitectura

## Vista general

```mermaid
graph LR
    A[Cliente] -->|HTTP| B[API FastAPI :8000]
    B -->|SQL| C[(PostgreSQL :5432)]
    B -->|HTTP| D[Ollama :11434]
    D --> E[Modelo gemma3:270m]
