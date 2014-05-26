# == Class: kegbot::install:pip
#
# Installs server via pip
#
# === Parameters
#
# === Variables
#
# [kegbot::install_dir]
#   Install directory for server
#
# === Authors
#
# Robbie Burda <github.com/burdara>
#
class kegbot::install::pip {
  contain kegbot

  $source_env_activate = "source ${::kegbot::install_dir}/bin/activate"
  $pip_install = "${::kegbot::install_dir}/bin/pip install -U kegbot"
  $install_command = "bash -c '${source_env_activate} && ${pip_install}'"
  exec { 'install_server':
    command => $install_command,
    creates => "${::kegbot::install_dir}/bin/kegbot",
    timeout => 600,
  }
}
