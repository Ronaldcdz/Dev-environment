#!/usr/bin/env zsh

# Variables
copy_mode=""
from=""
to=""
dry="0"
default_source="./dotfiles"  # Carpeta de origen por defecto

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
  local from_dir="$1"
  local to_dir="$2"

  log "Copiando directorio de $from_dir a $to_dir..."
  mkdir -p "$to_dir"  # Crear el directorio destino si no existe
  execute rm -rf "$to_dir"
  execute cp -r "$from_dir" "$to_dir"
}

copy_file() {
  local from_file="$1"
  local to_file="$2"

  log "Copiando archivo de $from_file a $to_file..."
  mkdir -p "$(dirname "$to_file")"  # Crear la carpeta destino si no existe
  execute rm -rf "$to_file"
  execute cp -r "$from_file" "$to_file"
}

# Si no se especifica --from, usar ./dotfiles como origen
if [[ -z "$from" ]]; then
  from="$default_source"
fi

# Si no se especifica un modo, copiar todo por defecto
if [[ -z "$copy_mode" ]]; then
  log "No se especificó --copy-dir o --copy-file, copiando configuraciones por defecto..."

  # Copiar Neovim
  copy_dir "$from/nvim" "$HOME/.config/nvim"

  # Copiar configuración de tmux
  copy_dir "$from/tmux/.tmux" "$HOME/.tmux"
  copy_file "$from/tmux/.tmux.conf" "$HOME/.tmux.conf"

  # Copiar archivos de Zsh
  copy_file "$from/zsh/.zshrc" "$HOME/.zshrc"
  copy_file "$from/zsh/.zprofile" "$HOME/.zprofile"
  copy_file "$from/zsh/.p10k.zsh" "$HOME/.p10k.zsh"

  log "✅ Configuraciones copiadas exitosamente."
  exit 0
fi

# Ejecutar la acción correspondiente
if [[ "$copy_mode" == "dir" ]]; then
  copy_dir "$from" "$to"
elif [[ "$copy_mode" == "file" ]]; then
  copy_file "$from" "$to"
fi
