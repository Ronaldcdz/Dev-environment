#!/usr/bin/env zsh

# Lista de herramientas a instalar
tools=(
    neovim
    ripgrep
    node
    lazygit
    nvm
    fzf
)

echo "Instalando herramientas esenciales..."

for tool in $tools; do
    if ! command -v $tool &> /dev/null; then
        echo "Instalando $tool..."
        brew install $tool
    else
        echo "$tool ya está instalado."
    fi
done

echo "✅ Instalación completada."
