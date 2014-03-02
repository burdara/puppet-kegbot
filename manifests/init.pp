# == Class: kegbot
#
# Installs Kegbot server and related dependencies
#
# === Parameters
#
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
# [kegbot_packages]
#   server package dependencies
#
# === Variables
#
# None
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
    $kegbot_packages = $::kegbot::params::kegbot_packages
) inherits kegbot::params {

    File { backup => '.puppet-bak' }
    Exec { path => ['/usr/bin', '/usr/sbin', '/bin'] }

    exec { 'apt_get_update':
        command => 'apt-get -y update'
    }

    include database
    include config
    include install
    include server

    Exec['apt_get_update'] ->
    Class['database'] ->
    Class['config'] ->
    Class['install'] ->
    Class['server']
}
