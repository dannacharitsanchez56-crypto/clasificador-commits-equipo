echo "=== Diagnóstico del entorno ==="
echo
echo "Git:      $(git --version 2>/dev/null || echo 'NO INSTALADO')"
echo "Python:   $(python3 --version 2>/dev/null || echo 'NO INSTALADO')"
echo "Pip:      $(pip3 --version 2>/dev/null || echo 'NO INSTALADO')"
echo "Docker:   $(docker --version 2>/dev/null || echo 'NO INSTALADO')"
echo "Compose:  $(docker compose version 2>/dev/null || echo 'NO INSTALADO')"
echo "Ollama:   $(ollama --version 2>/dev/null || echo 'NO INSTALADO')"
echo 
echo "=== Fin del diagnóstico ==="

