#!/usr/bin/env zsh

# Variables
copy_mode=""
from=""
to=""
dry="0"
default_source="$HOME/.dotfiles"  # Carpeta por defecto

# Procesar argumentos
while [[ $# -gt 0 ]]; do
  case "$1" in
    --copy-dir)
      copy_mode="dir"
      ;;
    --copy-file)
      copy_mode="file"
      ;;
    --from)
      shift
      from="$1"
      ;;
    --to)
      shift
      to="$1"
      ;;
    --dry)
      dry="1"
      ;;
    *)
      echo "Uso: $0 [--copy-dir | --copy-file] --from <ruta_origen> --to <ruta_destino> [--dry]"
      exit 1
      ;;
  esac
  shift
done

log() {
  if [[ $dry == "1" ]]; then
    echo "[DRY_RUN]: $@"
  else
    echo "$@"
  fi
}

execute() {
  log "execute $@"
  if [[ $dry == "1" ]]; then
    return
  fi
  "$@"
}

copy_dir() {
  log "Copiando directorio de $from a $to..."
  mkdir -p "$to"  # Asegurar que la carpeta destino exista
  pushd "$from" > /dev/null
  dirs=($(find . -maxdepth 1 -mindepth 1 -type d))
  for dir in $dirs; do
    execute rm -rf "$to/$dir"
    execute cp -r "$dir" "$to/$dir"
  done
  popd > /dev/null
}

copy_file() {
  log "Copiando archivo de $from a $to..."
  mkdir -p "$(dirname "$to")"  # Crear carpeta destino si no existe
  execute rm -rf "$to"
  execute cp -r "$from" "$to"
}

# Si no se especifica --from, usar .dotfiles como origen
if [[ -z "$from" ]]; then
  from="$default_source"
fi

# Si no se especifica un modo, copiar todo por defecto
if [[ -z "$copy_mode" ]]; then
  log "No se especificó --copy-dir o --copy-file, copiando configuraciones por defecto..."

  # Copiar Neovim
  copy_dir "$from/nvim" "$HOME/.config/nvim"

  # Copiar configuración de tmux
  copy_dir "$from/tmux/.tmux" "$HOME/"
  copy_file "$from/tmux/.tmux.conf" "$HOME/.tmux.conf"

  # Copiar archivos de Zsh
  copy_dir "$from/zsh" "$HOME/"

  log "✅ Configuraciones copiadas exitosamente."
  exit 0
fi

# Ejecutar la acción correspondiente
if [[ "$copy_mode" == "dir" ]]; then
  copy_dir
elif [[ "$copy_mode" == "file" ]]; then
  copy_file
fi
