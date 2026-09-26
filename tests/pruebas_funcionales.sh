#!/bin/bash

BASE_URL="http://localhost:8000"
PASS=0
FAIL=0

echo "======================================"
echo " PRUEBAS FUNCIONALES DEL CLASIFICADOR"
echo "======================================"

# P-01: Health
echo
echo "[P-01] GET /health"
RESP=$(curl -s $BASE_URL/health)
echo "Respuesta: $RESP"
if echo "$RESP" | grep -q '"estado":"ok"' && echo "$RESP" | grep -q '"base_datos":"ok"'; then
    echo "PASS"
    PASS=$((PASS+1))
else
    echo "FAIL"
    FAIL=$((FAIL+1))
fi

# P-02a: Clasificación feat
echo
echo "[P-02a] POST /clasificar feat"
RESP=$(curl -s -X POST $BASE_URL/clasificar -H "Content-Type: application/json" -d '{"mensaje":"agrega nueva funcion de login"}')
echo "Respuesta: $RESP"
if echo "$RESP" | grep -q '"tipo":"feat"'; then
    echo "PASS"
    PASS=$((PASS+1))
else
    echo "FAIL"
    FAIL=$((FAIL+1))
fi

# P-02b: Clasificación fix
echo
echo "[P-02b] POST /clasificar fix"
RESP=$(curl -s -X POST $BASE_URL/clasificar -H "Content-Type: application/json" -d '{"mensaje":"arregla bug en el login"}')
echo "Respuesta: $RESP"
if echo "$RESP" | grep -q '"tipo":"fix"'; then
    echo "PASS"
    PASS=$((PASS+1))
else
    echo "FAIL"
    FAIL=$((FAIL+1))
fi

# P-03: Validación (campo faltante)
echo
echo "[P-03] POST /clasificar sin campo mensaje"
CODE=$(curl -s -o /dev/null -w "%{http_code}" -X POST $BASE_URL/clasificar -H "Content-Type: application/json" -d '{}')
echo "Codigo HTTP: $CODE"
if [ "$CODE" = "422" ]; then
    echo "PASS (validacion correcta)"
    PASS=$((PASS+1))
else
    echo "FAIL"
    FAIL=$((FAIL+1))
fi

# P-07: Persistencia
echo
echo "[P-07] GET /inferencias"
RESP=$(curl -s $BASE_URL/inferencias)
echo "Respuesta: ${RESP:0:200}..."
if echo "$RESP" | grep -q '"id"'; then
    echo "PASS (hay inferencias registradas)"
    PASS=$((PASS+1))
else
    echo "FAIL"
    FAIL=$((FAIL+1))
fi

echo
echo "======================================"
echo " RESULTADO: $PASS PASS / $FAIL FAIL"
echo "======================================"

exit $FAIL
