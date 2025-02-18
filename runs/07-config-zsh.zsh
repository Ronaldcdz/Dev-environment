#!/usr/bin/env zsh

#########################
# 2. Descargar .zshrc   #
#########################

ZSHRC_URL="https://raw.githubusercontent.com/Ronaldcdz/dotfiles/main/zsh/.zshrc"
ZSHRC_PATH="$HOME/.zshrc"

# Si existe un .zshrc, lo respalda
# if [ -f "$ZSHRC_PATH" ]; then
#     echo "El archivo .zshrc ya existe, haciendo respaldo a .zshrc.bak..."
#     cp "$ZSHRC_PATH" "$HOME/.zshrc.bak"
# fi

echo "Descargando archivo de configuración de Zsh..."
if curl -fsSL "$ZSHRC_URL" -o "$ZSHRC_PATH"; then
    echo "Archivo .zshrc descargado correctamente."
else
    echo "Error al descargar .zshrc. Verifica la URL o tu conexión a internet."
    exit 1
fi


source ~/.zshrc
