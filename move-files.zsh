
#!/usr/bin/env zsh

# script_dir=$(cd $(dirname "$0") && pwd)
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
  "$@"
}

# log "$script_dir (filtro =>) $filter"
# cd "$script_dir"


log "---------------------- dev-env ----------------------"
copy_dir() {
  local from=$1
  local to=$2

  pushd "$from" > /dev/null
  dirs=($(find . -maxdepth 1 -mindepth 1 -type d))
  for dir in $dirs; do
    execute rm -rf "$to/$dir"
    execute cp -r "$dir" "$to/$dir"
  done
  popd > /dev/null
}

copy_file() {
  local from=$1
  local to=$2
  local name=$(basename "$from")

  execute rm -rf "$to/$name"
  execute cp -r "$from" "$to/$name"
}
