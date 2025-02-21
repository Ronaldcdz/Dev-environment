#!/usr/bin/env bash
set -e  # Detener el script en caso de error

#########################
# 1. Solicitar Contraseña y Mantener sudo Activo #
#########################

echo "Necesito tu contraseña para instalar paquetes."
sudo -v  # Solicita la contraseña una vez y la almacena

# Mantener sudo activo en segundo plano
(sleep 60; while true; do sudo -v; sleep 60; done) &  
SUDO_REFRESH_PID=$!  # Guardamos el PID del proceso de refresco

#########################
# 2. Configuración de Homebrew #
#########################

if ! command -v brew &>/dev/null; then
    echo "Instalando Homebrew..."

    # Ejecutar la instalación con privilegios elevados desde el inicio
    sudo -E bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

    # Cargar Homebrew en la sesión actual
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

    # Agregar Homebrew al .bashrc y .zshrc
    echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' | tee -a "$HOME/.bashrc" "$HOME/.zshrc"

    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

    sleep 3  # Esperar para asegurar que el entorno se haya cargado

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
sudo chsh -s "$(which zsh)" "$USER"

#########################
# 4. Ejecutar Zsh y Script2 #
#########################

echo "Ejecutando Zsh y lanzando run.zsh..."
zsh -c "./run.zsh"

# Finalizar el proceso de refresco de sudo
kill $SUDO_REFRESH_PID

# Iniciar Zsh al final
exec zsh -l
