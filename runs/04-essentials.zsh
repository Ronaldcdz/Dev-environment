#!/usr/bin/env zsh

# Verificar si make está instalado
if ! command -v make &> /dev/null; then
    echo "make no está instalado. Instalándolo..."
    sudo apt update && sudo apt install -y build-essential
else
    echo "make ya está instalado."
fi
