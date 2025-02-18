#!/usr/bin/env zsh

#########################
# 2. Descargar .zshrc   #
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
# 3. Instalar NVM       #
#########################

echo "Descargando e instalando NVM..."
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash

# Cargar NVM manualmente en el script
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

# Verificar si NVM se instaló correctamente
if command -v nvm &>/dev/null; then
    echo "✅ NVM instalado correctamente."
else
    echo "❌ Hubo un problema instalando NVM."
    exit 1
fi
