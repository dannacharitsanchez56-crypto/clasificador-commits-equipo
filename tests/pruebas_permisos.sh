#!/bin/bash

echo "======================================"
echo " PRUEBAS DE PERMISOS MINIMOS (P-04)"
echo "======================================"

# Probar INSERT (debe funcionar)
echo
echo "[P-04a] INSERT como app_ia"
docker compose exec -T db psql -U app_ia -d iadb -c "INSERT INTO inferencias (motor, modelo, entrada, salida, latencia_ms) VALUES ('eco', 'gemma3:270m', 'test permisos', 'chore', 5);"
if [ $? -eq 0 ]; then
    echo "PASS (INSERT permitido)"
else
    echo "FAIL"
fi

# Probar SELECT (debe funcionar)
echo
echo "[P-04b] SELECT como app_ia"
docker compose exec -T db psql -U app_ia -d iadb -c "SELECT COUNT(*) FROM inferencias;"
if [ $? -eq 0 ]; then
    echo "PASS (SELECT permitido)"
else
    echo "FAIL"
fi

# Probar DELETE (debe FALLAR)
echo
echo "[P-04c] DELETE como app_ia (debe fallar)"
docker compose exec -T db psql -U app_ia -d iadb -c "DELETE FROM inferencias;"
if [ $? -ne 0 ]; then
    echo "PASS (DELETE denegado correctamente)"
else
    echo "FAIL (DELETE no deberia estar permitido)"
fi

# Probar DROP (debe FALLAR)
echo
echo "[P-04d] DROP TABLE como app_ia (debe fallar)"
docker compose exec -T db psql -U app_ia -d iadb -c "DROP TABLE inferencias;"
if [ $? -ne 0 ]; then
    echo "PASS (DROP denegado correctamente)"
else
    echo "FAIL (DROP no deberia estar permitido)"
fi

echo
echo "======================================"
echo " FIN PRUEBAS DE PERMISOS"
echo "======================================"
