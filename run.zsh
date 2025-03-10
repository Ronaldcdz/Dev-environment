#!/usr/bin/env zsh

script_dir=$(cd $(dirname "$0") && pwd)
filter=""
dry="0"

while [[ $# -gt 0 ]]; do
  if [[ $1 == "--dry" ]]; then
    dry="1"
  else
    filter="$1"
  fi
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
  # Aquí pasamos la contraseña al script
  echo "$PASSWORD" | sudo -S "$@"
}

log "$script_dir (filtro =>) $filter"
cd "$script_dir"

# Buscar scripts y ordenarlos correctamente
scripts=($(find ./runs/ -maxdepth 1 -mindepth 1 -executable -type f | sort -V))

for script in $scripts; do
  if ! echo "$script" | grep -q "$filter"; then
    log "filtering $script"
    continue
  fi
  execute "$script"
done
