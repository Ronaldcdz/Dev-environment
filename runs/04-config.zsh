#!/usr/bin/env zsh

# Verificar si git está instalado, si no, instalarlo
if ! command -v git &>/dev/null; then
    echo "Instalando Git..."
    sudo apt update && sudo apt install -y git
fi

# Ruta de destino donde se guardarán los archivos de configuración
config_dir="$HOME/.config/nvim"

# URL del repositorio de configuración de Neovim en GitHub
repo_url="https://github.com/Ronaldcdz/dotfiles"

# Crear el directorio .config si no existe
mkdir -p "$HOME/.config"

# Clonar solo la carpeta 'nvim' usando sparse-checkout
echo "Descargando la configuración de Neovim desde GitHub..."
git clone --depth 1 --filter=blob:none "$repo_url" "$HOME/dotfiles_temp"
cd "$HOME/dotfiles_temp"
git sparse-checkout init --cone
git sparse-checkout set nvim

# Mover la configuración descargada a ~/.config/nvim
mv nvim "$config_dir"

# Limpiar archivos temporales
cd "$HOME"
rm -rf "$HOME/dotfiles_temp"

echo "✅ Configuración de Neovim descargada correctamente a $config_dir."

# Recargar la configuración del shell
source "$HOME/.zshrc"
