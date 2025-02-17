#!/usr/bin/env bash

# Descargar el archivo .zshrc antes de instalar cualquier cosa
ZSHRC_URL="https://raw.githubusercontent.com/Ronaldcdz/dotfiles/main/zsh/.zshrc"
ZSHRC_PATH="$HOME/.zshrc"

echo "Descargando archivo de configuración de Zsh..."
curl -fsSL "$ZSHRC_URL" -o "$ZSHRC_PATH" && echo "Archivo .zshrc descargado correctamente."

# Instalar Homebrew si no está instalado
if ! command -v brew &> /dev/null; then
    echo "Instalando Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

    # Cargar Homebrew en la sesión actual y agregarlo a Zsh
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
    echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' >> "$HOME/.zshrc"

    echo "Homebrew instalado y configurado correctamente."
fi

# Instalar Zsh si no está instalado
if ! command -v zsh &> /dev/null; then
    echo "Zsh no está instalado. Instalando Zsh..."
    brew install zsh

    # Verificar si la instalación fue exitosa
    if command -v zsh &> /dev/null; then
        echo "Zsh ha sido instalado correctamente."
    else
        echo "Hubo un error al instalar Zsh."
        exit 1
    fi
fi

# Establecer Zsh como shell predeterminado
echo "Estableciendo Zsh como shell predeterminado..."
chsh -s "$(which zsh)"

# Instalación de plugins y herramientas con Homebrew
echo "Instalando herramientas adicionales..."
brew install zsh-autosuggestions zsh-syntax-highlighting eza zoxide

# Agregar plugins a la configuración de Zsh
echo "source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh" >> "$HOME/.zshrc"
echo "source $(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" >> "$HOME/.zshrc"

# Recargar Zsh con la nueva configuración
echo "Recargando configuración de Zsh..."
exec zsh
