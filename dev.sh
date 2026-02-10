#!/usr/bin/env bash

# dev.sh - Script para gestionar configuraciones de nvim, tmux y zsh
# Uso: ./dev.sh [-from-home | -to-home | -h | --dry]

set -euo pipefail

# ──────────────────────────────────────────────────────────────────────────────
# Ayuda
# ──────────────────────────────────────────────────────────────────────────────

show_help() {
    echo "Script para sincronizar solo nvim, tmux y zsh."
    echo ""
    echo "Uso: ./dev.sh [-from-home | -to-home] [--dry] [-h]"
    echo ""
    echo "Opciones:"
    echo "  -from-home    Copia desde \$HOME hacia dotfiles/"
    echo "  -to-home      Copia desde dotfiles/ hacia \$HOME"
    echo "  --dry         Simula la operación (muestra qué se haría, sin copiar ni borrar)"
    echo "  -h, --help    Muestra esta ayuda"
    echo ""
    echo "Archivos/carpetas manejados:"
    echo "  • ~/.config/nvim     ↔  dotfiles/nvim"
    echo "  • ~/.tmux.conf       ↔  dotfiles/tmux/.tmux.conf"
    echo "  • ~/.zshrc           ↔  dotfiles/zsh/.zshrc"
    echo "  • ~/.zprofile        ↔  dotfiles/zsh/.zprofile"
    echo "  • ~/.p10k.zsh        ↔  dotfiles/zsh/.p10k.zsh"
    echo ""
    exit 0
}

# ──────────────────────────────────────────────────────────────────────────────
# Parseo de argumentos
# ──────────────────────────────────────────────────────────────────────────────

FROM_HOME=false
TO_HOME=false
DRY_RUN=false

while [[ $# -gt 0 ]]; do
    case $1 in
        -from-home) FROM_HOME=true ;;
        -to-home)   TO_HOME=true ;;
        --dry)      DRY_RUN=true ;;
        -h|--help)  show_help ;;
        *) echo "Opción desconocida: $1" >&2; exit 1 ;;
    esac
    shift
done

# Validaciones
if [[ $FROM_HOME == true && $TO_HOME == true ]]; then
    echo "Error: no puedes usar -from-home y -to-home al mismo tiempo" >&2
    exit 1
fi

if [[ $FROM_HOME == false && $TO_HOME == false ]]; then
    echo "Error: debes especificar -from-home o -to-home" >&2
    exit 1
fi

# ──────────────────────────────────────────────────────────────────────────────
# Rutas
# ──────────────────────────────────────────────────────────────────────────────

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOTFILES_DIR="$REPO_DIR/dotfiles"

# ──────────────────────────────────────────────────────────────────────────────
# Definición de items
# ──────────────────────────────────────────────────────────────────────────────

declare -A ITEMS

ITEMS["nvim"]="~/.config/nvim → nvim"
ITEMS["tmux"]="~/.tmux.conf → tmux/.tmux.conf"
ITEMS["zsh.zshrc"]="~/.zshrc → zsh/.zshrc"
ITEMS["zsh.zprofile"]="~/.zprofile → zsh/.zprofile"
ITEMS["zsh.p10k"]="~/.p10k.zsh → zsh/.p10k.zsh"

# ──────────────────────────────────────────────────────────────────────────────
# Funciones
# ──────────────────────────────────────────────────────────────────────────────

log() {
    echo "$1"
}

dry_log() {
    if $DRY_RUN; then
        echo "[DRY-RUN] $1"
    else
        echo "$1"
    fi
}

clean_destination() {
    local path="$1"
    if [[ -d "$path" ]]; then
        if $DRY_RUN; then
            dry_log "Se limpiaría (rm -rf) el contenido de: $path"
        else
            rm -rf "${path:?}"/*
            log "   Limpiado: $path"
        fi
    fi
}

copy_item() {
    local src="$1"
    local dst="$2"

    src=$(eval echo "$src")
    dst=$(eval echo "$dst")

    if [[ ! -e "$src" ]]; then
        echo "   No existe → omitiendo: $src" >&2
        return
    fi

    if $DRY_RUN; then
        if [[ -d "$src" ]]; then
            dry_log "Se copiaría carpeta (cp -rf) $src → $dst"
            dry_log "Se limpiaría antes el destino: $dst"
        else
            dry_log "Se copiaría archivo (cp -f) $src → $dst"
        fi
        return
    fi

    # Ejecución real
    mkdir -p "$(dirname "$dst")"

    if [[ -d "$src" ]]; then
        clean_destination "$dst"
        mkdir -p "$dst"
        cp -rf "$src"/* "$dst"/
        log "   Copiada carpeta: $src → $dst"
    else
        cp -f "$src" "$dst"
        log "   Copiado archivo: $src → $dst"
    fi
}

# ──────────────────────────────────────────────────────────────────────────────
# Ejecución principal
# ──────────────────────────────────────────────────────────────────────────────

if $FROM_HOME; then
    DIRECTION="desde \$HOME → dotfiles"
else
    DIRECTION="desde dotfiles → \$HOME"
fi

if $DRY_RUN; then
    echo "MODO SIMULACIÓN (--dry) - nada se modificará"
    echo ""
fi

echo "Sincronizando configuraciones $DIRECTION..."
echo ""

for key in "${!ITEMS[@]}"; do
    IFS=' → ' read -r src_rel dst_rel <<< "${ITEMS[$key]}"

    if $FROM_HOME; then
        source_path="$src_rel"
        dest_path="$DOTFILES_DIR/$dst_rel"
    else
        source_path="$DOTFILES_DIR/$dst_rel"
        dest_path="$src_rel"
    fi

    dest_path=$(eval echo "$dest_path")

    echo "→ $key"
    copy_item "$source_path" "$dest_path"
    echo ""
done

echo "Operación completada: $DIRECTION"
if $DRY_RUN; then
    echo "(modo dry-run: no se realizó ningún cambio)"
fi
echo ""
