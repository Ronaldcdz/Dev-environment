#!/usr/bin/env zsh

USER_NAME=$(whoami)  # Obtiene el nombre del usuario actual

if ! command -v brew &>/dev/null; then
    echo "Instalando Homebrew..."
    /bin/zsh -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

    # Cargar Homebrew en la sesión actual
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
    
    # Descargar configuraciones .zshrc y .zprofile
    echo "Descargando configuraciones .zshrc y .zprofile..."
    curl -fsSL https://github.com/Ronaldcdz/dotfiles/blob/main/zsh/.zshrc -o "$HOME/.zshrc"
    curl -fsSL https://github.com/Ronaldcdz/dotfiles/blob/main/zsh/.zprofile -o "$HOME/.zprofile"

    # Agregar las líneas para cargar Homebrew en futuras sesiones
    echo >> /home/ronald/.bashrc    echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' >> /home/ronald/.bashrc
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
