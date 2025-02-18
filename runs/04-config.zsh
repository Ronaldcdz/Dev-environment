#!/usr/bin/env zsh

# Ruta de destino donde se guardarán los archivos de configuración
config_dir="$HOME/.config/nvim"

# URL de la carpeta de configuración de nvim en GitHub
repo_url="https://github.com/Ronaldcdz/dotfiles/trunk/nvim"

# Crear el directorio .config/nvim si no existe
mkdir -p "$config_dir"

# Descargar la carpeta nvim desde GitHub utilizando svn
echo "Descargando la configuración de Neovim desde GitHub..."
svn export "$repo_url" "$config_dir"

echo "✅ Configuración de Neovim descargada correctamente a $config_dir."
source "$HOME/.zshrc"
