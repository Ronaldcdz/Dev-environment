#!/usr/bin/env zsh

# Comprobar si Homebrew ya está instalado
if command -v brew &> /dev/null; then
  echo "Homebrew ya está instalado."
  exit 0  # Si ya está instalado, terminamos el script aquí
fi

# Si Homebrew no está instalado, proceder con la instalación y configuración
echo "Homebrew no está instalado. Instalando..."

# Instalar Homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Configurar Homebrew si se instaló
test -d ~/.linuxbrew && eval "$(~/.linuxbrew/bin/brew shellenv)"
test -d /home/linuxbrew/.linuxbrew && eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

# Añadir Homebrew a .zshrc si está instalado
echo "eval \"\$($(brew --prefix)/bin/brew shellenv)\"" >> ~/.zshrc

# Recargar el archivo .zshrc para aplicar los cambios inmediatamente
echo "Recargando la configuración de Zsh..."
source ~/.zshrc
