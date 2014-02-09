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
    $install_dir   = hiera('kegbot::install_dir',   '/opt/kegbot')
    $data_dir      = hiera('kegbot::data_dir',      '/opt/kegbot/data')
    $config_dir    = hiera('kegbot::config_dir',    '/etc/kegbot')
    $log_dir       = hiera('kegbot::log_dir',       '/var/log/kegbot')
    $database_type = hiera('kegbot::database_type', 'sqlite')
    $kegbot_pwd    = hiera('kegbot::kegbot_pwd',    'beerMe123')
    $bind          = hiera('kegbot::bind',          '0.0.0.0:8000')
    $config_file   = hiera('kegbot::config_file',   "${config_dir}/config.gflags")
    $mysql_pwd     = hiera('kegbot::mysql_pwd',     'beerMysql123')
    $kegbot_packages = [
        'build-essential',
        'git-core',
        'libjpeg-dev',
        'libmysqlclient-dev',
        'libsqlite3-0',
        'libsqlite3-dev',
        'memcached',
        'mysql-client',
        'mysql-server',
        'python-dev',
        'python-imaging',
        'python-mysqldb',
        'python-pip',
        'python-virtualenv',
        'virtualenvwrapper'
    ]
    $mysql_packages = [
        'mysql-server'
    ]
    $sqlite_packages = [
        'python-sqlite'
    ]
}
