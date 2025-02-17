#!/usr/bin/env bash
set -e  # Detener el script en caso de error

#########################
# 1. Descargar .zshrc   #
#########################

ZSHRC_URL="https://raw.githubusercontent.com/Ronaldcdz/dotfiles/main/zsh/.zshrc"
ZSHRC_PATH="$HOME/.zshrc"

# Si existe un .zshrc, lo respalda
if [ -f "$ZSHRC_PATH" ]; then
    echo "El archivo .zshrc ya existe, haciendo respaldo a .zshrc.bak..."
    cp "$ZSHRC_PATH" "$HOME/.zshrc.bak"
fi

echo "Descargando archivo de configuración de Zsh..."
if curl -fsSL "$ZSHRC_URL" -o "$ZSHRC_PATH"; then
    echo "Archivo .zshrc descargado correctamente."
else
    echo "Error al descargar .zshrc. Verifica la URL o tu conexión a internet."
    exit 1
fi

#########################
# 2. Instalar Zsh       #
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
# 3. Ejecutar Zsh       #
#########################

echo "Ejecutando Zsh..."
exec zsh -l  # Inicia Zsh con una sesión de login
