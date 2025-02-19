#!/usr/bin/env zsh

# Variables
copy_mode=""
from=""
to=""
dry="0"

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

# Validar parámetros
if [[ -z "$copy_mode" || -z "$from" || -z "$to" ]]; then
  echo "Error: Debes especificar --copy-dir o --copy-file, y proporcionar --from y --to."
  exit 1
fi

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
  local name=$(basename "$from")
  execute rm -rf "$to/$name"
  execute cp -r "$from" "$to/$name"
}

# Ejecutar la acción correspondiente
if [[ "$copy_mode" == "dir" ]]; then
  copy_dir
elif [[ "$copy_mode" == "file" ]]; then
  copy_file
fi
