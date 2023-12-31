#!/bin/bash

# source this file to add functions to the dotpi environment

dotpi_manager_update() {
  _dotpi_command="$(basename -- "${FUNCNAME[0]:-"$0"}")"
  log_file="${DOTPI_ROOT}/var/log/${_dotpi_command}_$(date +"%Y%m%d-%H%M%S").log"
  exec &> >(dotpi log "$log_file")

  dotpi echo_info "Log of dotpi-manager update: ${log_file}"

  cd -- "${DOTPI_ROOT}/share/dotpi-manager/runtime"

  service_name='dotpi-manager.service'

  systemctl stop "${service_name}"

  git pull origin main
  rm -rf node_modules
  npm install
  npm run build

  systemctl start "${service_name}"
}
