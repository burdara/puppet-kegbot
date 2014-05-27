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
  $install_src     = hiera('kegbot::install_src', 'pip')
  $install_dir     = hiera('kegbot::install_dir', '/opt/kegbot')
  $data_dir        = hiera('kegbot::data_dir',    '/opt/kegbot/data')
  $config_dir      = hiera('kegbot::config_dir',  '/etc/kegbot')
  $log_dir         = hiera('kegbot::log_dir',     '/var/log/kegbot')
  $bind            = hiera('kegbot::bind',        '0.0.0.0:8000')
  $config_file     = hiera('kegbot::config_file', "${config_dir}/config.gflags")
  $debug_mode      = hiera('kegbot::debug_mode',  'true')
  $kegbot_packages = [
    'python-dev',
    'python-pip',
    'libjpeg-dev',
    'libmysqlclient-dev',
    'redis-server',
    'mysql-client',
    'mysql-server',
    'redis-server',
    'supervisor',
    'nginx'
  ]

  # kegbot:database
  $database_type    = hiera('kegbot::database_type', 'mysql')
  $database_name    = hiera('kegbot::database_name', 'kegbot')
  $kegbot_usr       = hiera('kegbot::kegbot_usr',    'kegbot')
  $kegbot_pwd       = hiera('kegbot::kegbot_pwd',    'beerMe123')
  $db_root_usr      = hiera('kegbot::db_root_usr',   'root')
  $db_root_pwd      = hiera('kegbot::db_root_pwd',   'beerMysql123')

  # kegbot::extra
  $extra_sentry_url = hiera('kegbot::extra::sentry_url', 'http://foo:bar@localhost:9000/2')
}
