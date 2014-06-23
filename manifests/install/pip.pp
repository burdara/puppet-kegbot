# == Class: kegbot::install:pip
#
# Installs server via pip
#
# === Parameters
#
# [*install_directory*]
#   Install directory for server
# [*user*]
#   application user
# [*group*]
#   application user group
#
# === Variables
#
# === Authors
#
# Robbie Burda <github.com/burdara>
#
class kegbot::install::pip (
  $install_path
){
  $source_env_activate = "source ${::kegbot::instance::path}/bin/activate"
  $pip_install = "${::kegbot::instance::path}/bin/pip install -U kegbot"
  $install_command = "bash -c '${source_env_activate} && ${pip_install}'"
  exec { 'install_server':
    command => $install_command,
    creates => "${::kegbot::instance::path}/bin/kegbot",
    timeout => 600,
    user    => $user,
    group   => $group,
  }
}
