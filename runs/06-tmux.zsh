#!/usr/bin/env zsh

# Instalar tmux si no está instalado
if ! command -v tmux &> /dev/null; then
    echo "Instalando tmux..."
    brew install tmux
fi

# Descargar el archivo de configuración .tmux.conf desde el nuevo repositorio de GitHub
echo "Descargando archivo de configuración de tmux..."
curl -fsSL https://raw.githubusercontent.com/Ronaldcdz/dotfiles/main/tmux/.tmux.conf --output ~/.tmux.conf

# Clonar el repositorio de Tmux Plugin Manager (TPM)
if [ ! -d "$HOME/.tmux/plugins/tpm" ]; then
    echo "Clonando TPM..."
    git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
else
    echo "TPM ya está instalado."
fi

# Si tmux no está en ejecución, se inicia una nueva sesión de tmux
if ! tmux has-session 2>/dev/null; then
    echo "Iniciando una nueva sesión de tmux..."
    tmux new-session -d -s setup_tmux
else
    echo "tmux ya está en ejecución."
fi

# Recargar configuración de tmux
echo "Recargando configuración de tmux..."
tmux source ~/.tmux.conf

# Instalar plugins de tmux usando TPM
echo "Instalando plugins de tmux..."
~/.tmux/plugins/tpm/bin/install_plugins
source ~/.zshrc
