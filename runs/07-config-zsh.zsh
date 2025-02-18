#!/usr/bin/env zsh

#########################
# 1. Descargar .zshrc   #
#########################

ZSHRC_URL="https://raw.githubusercontent.com/Ronaldcdz/dotfiles/main/zsh/.zshrc"
ZSHRC_PATH="$HOME/.zshrc"

echo "Descargando archivo de configuración de Zsh..."
if curl -fsSL "$ZSHRC_URL" -o "$ZSHRC_PATH"; then
    echo "Archivo .zshrc descargado correctamente."
else
    echo "Error al descargar .zshrc. Verifica la URL o tu conexión a internet."
    exit 1
fi

#########################
# 2. Instalar NVM       #
#########################

echo "Descargando e instalando NVM..."
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash

# Cargar NVM manualmente en la sesión actual
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

# Agregar la carga de NVM al inicio de tmux
echo 'export NVM_DIR="$HOME/.nvm"' >> "$HOME/.zshrc"
echo '[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"' >> "$HOME/.zshrc"

# Verificar si NVM se instaló correctamente
if command -v nvm &>/dev/null; then
    echo "✅ NVM instalado correctamente."
else
    echo "❌ Hubo un problema instalando NVM."
    exit 1
fi

#########################
# 3. Verificar en tmux  #
#########################

if command -v tmux &>/dev/null; then
    echo "Verificando si tmux está corriendo..."
    
    # Si tmux ya está corriendo, enviar el comando para recargar el entorno
    if tmux has-session 2>/dev/null; then
        echo "Recargando entorno de NVM en tmux..."
        tmux send-keys "export NVM_DIR=\"$HOME/.nvm\"" C-m
        tmux send-keys "[ -s \"$NVM_DIR/nvm.sh\" ] && \. \"$NVM_DIR/nvm.sh\"" C-m
        tmux send-keys "nvm --version" C-m
    fi
fi
