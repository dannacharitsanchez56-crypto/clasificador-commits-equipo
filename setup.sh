echo "=== Iniciando setup del entorno ==="
sudo apt update && sudo apt upgrade -y
echo "[2/4] Instalando herramientas básicas..."
sudo apt install -y curl git ca-certificates nano python3-venv python3-pip docker.io docker-compose-v2
echo "[3/4] Configurando Docker para el usuario actual..."
sudo usermod -aG docker $USER
echo "[4/4] Setup completado."
echo "Cierra la terminal y ábrela de nuevo para aplicar permisos de Docker."

