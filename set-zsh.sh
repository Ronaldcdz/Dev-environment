#!/usr/bin/env bash
set -e  # Detener el script en caso de error

#########################
# 1. Configuración de Homebrew #
#########################

USER_NAME=$(whoami)  # Obtiene el nombre del usuario actual

if ! command -v brew &>/dev/null; then
    echo "Instalando Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

    # Cargar Homebrew en la sesión actual
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
    
    # Descargar configuraciones .bashrc y .bash_profile
    echo "Descargando configuraciones .bashrc y .bash_profile..."
    curl -fsSL https://github.com/Ronaldcdz/dotfiles/blob/main/zsh/.zshrc -o "$HOME/.bashrc"
    curl -fsSL https://github.com/Ronaldcdz/dotfiles/blob/main/zsh/.zprofile -o "$HOME/.bash_profile"

    # Agregar las líneas para cargar Homebrew en futuras sesiones
    echo >> /home/$USER_NAME/.bashrc
    echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' >> /home/$USER_NAME/.bashrc
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

    # Esperar un segundo para asegurar que el entorno se haya cargado
    sleep 1

    # Verificar si brew funciona
    if command -v brew &>/dev/null; then
        echo "Homebrew instalado y cargado correctamente."
    else
        echo "Hubo un problema cargando Homebrew."
        exit 1
    fi

else
    echo "Homebrew ya está instalado."
fi

#########################
# 2. Descargar .zshrc   #
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
# 3. Instalar Zsh       #
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
# 4. Ejecutar Zsh       #
#########################

echo "Ejecutando Zsh..."
exec zsh -l  # Inicia Zsh con una sesión de login
