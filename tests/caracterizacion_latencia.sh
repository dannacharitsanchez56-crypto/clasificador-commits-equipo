#!/bin/bash

echo "======================================"
echo " CARACTERIZACION DE LATENCIA (P-09)"
echo "======================================"
echo
echo "Enviando 10 inferencias secuenciales a Ollama..."
echo

TIEMPOS=()
RESPUESTAS=()

for i in $(seq 1 10); do
    INICIO=$(date +%s%N)
    RESP=$(curl -s http://localhost:11434/api/generate -d "{\"model\":\"gemma3:270m\",\"prompt\":\"Clasifica este mensaje de commit en una palabra (feat, fix, docs, test, chore, refactor): cambio numero $i\",\"stream\":false}")
    FIN=$(date +%s%N)
    LATENCIA=$(( (FIN - INICIO) / 1000000 ))
    TIEMPOS+=($LATENCIA)
    
    TIPO=$(echo "$RESP" | grep -o '"response":"[^"]*"' | head -1 | cut -d'"' -f4 | tr -d '\n' | head -c 30)
    RESPUESTAS+=("$TIPO")
    
    echo "$i. ${LATENCIA} ms -> $TIPO"
done

echo
echo "Calculando estadisticas..."

# Ordenar tiempos
IFS=$'\n' SORTED=($(sort -n <<<"${TIEMPOS[*]}")); unset IFS

# Promedio
SUMA=0
for T in "${TIEMPOS[@]}"; do
    SUMA=$((SUMA + T))
done
PROMEDIO=$((SUMA / 10))

# Mediana (posiciones 5 y 6 en base 0 -> indices 4 y 5)
MEDIANA=$(( (SORTED[4] + SORTED[5]) / 2 ))

# P95 (indice 9 en base 0, aproximado)
P95=${SORTED[9]}

echo
echo "======================================"
echo " Promedio:  ${PROMEDIO} ms"
echo " Mediana:   ${MEDIANA} ms"
echo " p95:       ${P95} ms"
echo "======================================"
