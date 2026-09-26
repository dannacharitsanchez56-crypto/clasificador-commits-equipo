#!/bin/bash

echo "======================================"
echo " PRUEBAS DE INFRAESTRUCTURA (P-05, P-06)"
echo "======================================"

# P-05: Conectividad API -> BD
echo
echo "[P-05] Conectividad API -> PostgreSQL"
RESP=$(curl -s http://localhost:8000/health)
echo "Respuesta: $RESP"
if echo "$RESP" | grep -q '"base_datos":"ok"'; then
    echo "PASS (API conectada a BD)"
else
    echo "FAIL"
fi

# P-06: Disponibilidad de contenedores
echo
echo "[P-06] Estado de contenedores con docker compose ps"
docker compose ps
API_UP=$(docker compose ps api | grep -c "Up")
DB_UP=$(docker compose ps db | grep -c "Up")
if [ "$API_UP" -ge 1 ] && [ "$DB_UP" -ge 1 ]; then
    echo "PASS (ambos contenedores arriba)"
else
    echo "FAIL"
fi

# P-06b: Healthcheck de db
echo
echo "[P-06b] Healthcheck de PostgreSQL"
docker compose ps db | grep -q "healthy"
if [ $? -eq 0 ]; then
    echo "PASS (db healthy)"
else
    echo "FAIL (db no healthy)"
fi

echo
echo "======================================"
echo " FIN PRUEBAS DE INFRAESTRUCTURA"
echo "======================================"
