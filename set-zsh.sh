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
# 3. Instalar Homebrew  #
#########################

if ! command -v brew &> /dev/null; then
    echo "Instalando Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    # Cargar Homebrew en la sesión actual
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
    # Agregar la configuración de Homebrew al .zshrc para futuras sesiones
    echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' >> "$HOME/.zshrc"
    echo "Homebrew instalado y configurado correctamente."
else
    echo "Homebrew ya está instalado."
fi

###########################################
# 4. Instalar herramientas y plugins      #
###########################################

echo "Instalando herramientas adicionales con Homebrew..."
brew install zsh-autosuggestions zsh-syntax-highlighting eza zoxide

# Agregar configuraciones de plugins al .zshrc si no existen ya
if ! grep -q "zsh-autosuggestions.zsh" "$HOME/.zshrc"; then
    echo "source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh" >> "$HOME/.zshrc"
fi

if ! grep -q "zsh-syntax-highlighting.zsh" "$HOME/.zshrc"; then
    echo "source $(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" >> "$HOME/.zshrc"
fi

###########################################
# 5. Recargar configuración y ejecutar Zsh #
###########################################

echo "Recargando configuración de Zsh..."
# Source el .zshrc para aplicar todas las configuraciones
source "$HOME/.zshrc"

echo "Configuración completada. Ejecutando Zsh..."
exec zsh
source "$HOME/.zshrc"
