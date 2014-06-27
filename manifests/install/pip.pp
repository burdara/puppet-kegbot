# == Defined Type: kegbot::install:pip
#
# Installs server via pip
#
# === Parameters
#
# [*path*]
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
  $path  = undef,
  $user  = $::kegbot::params::default_kegbot_user,
  $group = $::kegbot::params::default_kegbot_group,
){
  $source_env_activate = "source ${path}/bin/activate"
  $pip_install = "${path}/bin/pip install -U kegbot"
  $install_command = "bash -c '${source_env_activate} && ${pip_install}'"

  exec { 'install_server':
    command => $install_command,
    creates => "${path}/bin/kegbot",
    timeout => 600,
    user    => $user,
    group   => $group,
  }
}
