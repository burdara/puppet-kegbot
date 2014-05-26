# == Class: kegbot
#
# Installs Kegbot server and related dependencies
#
# === Parameters
#
# [install_src]
#   server installation source
# [install_dir]
#   server installation directory
# [data_dir]
#   server data directory
# [config_dir]
#   server config directory
# [log_dir]
#   server log directory
# [database_type]
#   server database type. Supports sqlite and mysql currently
# [kegbot_pwd]
#   server password
# [bind]
#   binding IP address: 0.0.0.0:8000
# [config_file]
#   server setup config gFlags file
# [debug_mode]
#   turn debug mode on and off
# [kegbot_packages]
#   server package dependencies
#
# === Variables
#
# === Authors
#
# Robbie Burda <github.com/burdara>
# Tyler Walters <github.com/tylerwalts>
#
class kegbot (
  $install_src     = $::kegbot::params::install_src,
  $install_dir     = $::kegbot::params::install_dir,
  $data_dir        = $::kegbot::params::data_dir,
  $config_dir      = $::kegbot::params::config_dir,
  $log_dir         = $::kegbot::params::log_dir,
  $database_name   = $::kegbot::params::database_name,
  $database_type   = $::kegbot::params::database_type,
  $kegbot_usr      = $::kegbot::params::kegbot_usr,
  $kegbot_pwd      = $::kegbot::params::kegbot_pwd,
  $bind            = $::kegbot::params::bind,
  $config_file     = $::kegbot::params::config_file,
  $kegbot_packages = $::kegbot::params::kegbot_packages,
  $debug_mode      = $::kegbot::params::debug_mode,
  $db_root_usr     = $::kegbot::params::db_root_usr,
  $db_root_pwd     = $::kegbot::params::db_root_pwd
) inherits ::kegbot::params {
  validate_bool($debug_mode)

  File { backup => '.puppet-bak' }
  Exec { path => ['/usr/bin', '/usr/sbin', '/bin'] }

  exec { 'apt_get_update':
    command => 'apt-get -y update'
  }

  include kegbot::database
  include kegbot::config
  include kegbot::install
  include kegbot::server

  Exec['apt_get_update'] ->
  Class['kegbot::database'] ->
  Class['kegbot::config'] ->
  Class['kegbot::install'] ->
  Class['kegbot::server']

  case $::osfamily {
    Debian:  {}
    default: { warn("The Kegbot module is untested on ${osfamily}!  Please feel free to submit an issue or pull request.") }
  }
}
