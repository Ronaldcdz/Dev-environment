#!/usr/bin/env bash

# Descargar el archivo .zshrc antes de instalar Zsh
ZSHRC_URL="https://raw.githubusercontent.com/Ronaldcdz/dotfiles/main/zsh/.zshrc"
ZSHRC_PATH="$HOME/.zshrc"

echo "Descargando archivo de configuración de Zsh..."
if curl -fsSL "$ZSHRC_URL" -o "$ZSHRC_PATH"; then
    echo "Archivo .zshrc descargado correctamente."
else
    echo "Error al descargar .zshrc. Verifica la URL o tu conexión a internet."
    exit 1
fi

# Verificar si Zsh está instalado
if ! command -v zsh &> /dev/null; then
    echo "Zsh no está instalado. Instalando Zsh..."

    # Actualizar repositorios e instalar Zsh
    sudo apt update && sudo apt install -y zsh

    # Verificar si la instalación fue exitosa
    if command -v zsh &> /dev/null; then
        echo "Zsh ha sido instalado correctamente."
    else
        echo "Hubo un error al instalar Zsh."
        exit 1
    fi
else
    echo "Zsh ya está instalado."
fi





# Instalación de zsh-autosuggestions
brew install zsh-autosuggestions
echo "source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh" >> ~/.zshrc
source ~/.zshrc

# Instalación de zsh-syntax-highlighting
brew install zsh-syntax-highlighting
echo "source $(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" >> ~/.zshrc
source ~/.zshrc

# Instalación de eza
brew install eza

# Instalación de zoxide
brew install zoxide

# Descargar el archivo .zshrc desde GitHub
echo "Descargando archivo .zshrc desde GitHub..."
curl -fsSL https://raw.githubusercontent.com/Ronaldcdz/dotfiles/main/zsh/.zshrc -o ~/.zshrc

# Recargar .zshrc para aplicar todos los cambios
source ~/.zshrc




# Establecer Zsh como shell predeterminado
echo "Estableciendo Zsh como shell predeterminado..."
chsh -s "$(which zsh)"

# Ejecutar Zsh inmediatamente
echo "Ejecutando Zsh ahora..."
exec zsh


echo "Configuración completada."
