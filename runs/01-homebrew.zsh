#!/usr/bin/env zsh

if ! command -v brew &>/dev/null; then
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
