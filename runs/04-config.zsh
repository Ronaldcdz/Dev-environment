#!/usr/bin/env zsh

# Verificar si svn está instalado, si no, instalarlo
if ! command -v svn &>/dev/null; then
    echo "Instalando subversion (svn)..."
    sudo apt update && sudo apt install -y subversion

    # Refrescar los comandos disponibles en la sesión actual
    hash -r
fi

# Ruta de destino donde se guardarán los archivos de configuración
config_dir="$HOME/.config/nvim"

# URL de la carpeta de configuración de nvim en GitHub
repo_url="https://github.com/Ronaldcdz/dotfiles/trunk/nvim"

# Crear el directorio .config/nvim si no existe
mkdir -p "$config_dir"

# Descargar la carpeta nvim desde GitHub utilizando svn
echo "Descargando la configuración de Neovim desde GitHub..."
svn export --force "$repo_url" "$config_dir"

echo "✅ Configuración de Neovim descargada correctamente a $config_dir."

# Recargar la configuración del shell
source "$HOME/.zshrc"
