#!/usr/bin/env bash
set -e  # Detener el script en caso de error

#########################
# 1. Instalar Zsh       #
#########################

if ! command -v zsh &> /dev/null; then
    echo "Zsh no está instalado. Instalando Zsh..."
    sudo apt update && sudo apt install -y zsh
    if command -v zsh &> /dev/null; then
        echo "Zsh ha sido instalado correctamente."
    else
        echo "Hubo un error al instalar Zsh."
        exit 1
    fi
else
    echo "Zsh ya está instalado."
fi

echo "Estableciendo Zsh como shell predeterminado..."
chsh -s "$(which zsh)"

#########################
# 2. Ejecutar Zsh      #
#########################

echo "Ejecutando Zsh..."
exec zsh -l  # Inicia Zsh con una sesión de login
