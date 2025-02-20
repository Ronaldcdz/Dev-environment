#!/usr/bin/env bash
set -e  # Detener el script en caso de error

#########################
# 1. Solicitar Contraseña #
#########################
read -s -p "Introduce tu contraseña: " PASSWORD
export PASSWORD  # Exportar para que `run.sh` la use
echo

#########################
# 2. Configuración de Homebrew #
#########################

USER_NAME=$(whoami)  # Obtiene el nombre del usuario actual

if ! command -v brew &>/dev/null; then
    echo "Instalando Homebrew..."
    echo "$PASSWORD" | sudo -S /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

    # Cargar Homebrew en la sesión actual
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

    # Agregar Homebrew al .bashrc y .zshrc
    echo >> /home/$USER_NAME/.bashrc
    echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' >> /home/$USER_NAME/.bashrc
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

    echo >> /home/$USER_NAME/.zshrc
    echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' >> /home/$USER_NAME/.zshrc
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

    sleep 3  # Esperar un segundo para asegurar que el entorno se haya cargado

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
    echo "$PASSWORD" | sudo -S apt update
    echo "$PASSWORD" | sudo -S apt install -y zsh
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
echo "$PASSWORD" | sudo -S chsh -s "$(which zsh)" "$USER_NAME"

#########################
# 4. Ejecutar Zsh y Script2 #
#########################

echo "Ejecutando Zsh y lanzando run.zsh..."
zsh -c "./run.zsh && unset PASSWORD && ./dev.zsh"

# Iniciar Zsh al final
exec zsh -l
