# == Class: kegbot::params
#
# Parameters for Kegbot
#
# === Parameters
#
# === Variables
#
# === Authors
#
# Robbie Burda <github.com/burdara>
# Tyler Walters <github.com/tylerwalts>
#
class kegbot::params {
  # init.pp
  $default_base_path      = hiera('kegbot::base_path',      '/srv')
  $default_kegbot_user    = hiera('kegbot::kegbot_user',    'kegbot')
  $default_kegbot_group   = hiera('kegbot::kegbot_group',   'kegbot')

  # instance.pp
  $default_install_source = hiera('kegbot::instance::install_source', 'pip')
  $default_server_port    = hiera('kegbot::instance::server_port',    '8000')
  $default_debug_mode     = hiera('kegbot::instance::debug_mode',     true)

  $default_database_name            = hiera('kegbot::instance::database_name',            'kegbot')
  $default_database_root_user       = hiera('kegbot::instance::database_root_user',       'root')
  $default_database_root_password   = hiera('kegbot::instance::database_root_password',   'beerMysql123')
  $default_database_kegbot_user     = hiera('kegbot::instance::database_kegbot_user',     'kegbot')
  $default_database_kegbot_password = hiera('kegbot::instance::database_kegbot_password', 'beerMe123')

  $default_environment = hiera('kegbot::environment', 'prod')

}
