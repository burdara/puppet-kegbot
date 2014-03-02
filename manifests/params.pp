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
    $install_src   = hiera('kegbot::install_src',   'github')
    $install_dir   = hiera('kegbot::install_dir',   '/opt/kegbot')
    $data_dir      = hiera('kegbot::data_dir',      '/opt/kegbot/data')
    $config_dir    = hiera('kegbot::config_dir',    '/etc/kegbot')
    $log_dir       = hiera('kegbot::log_dir',       '/var/log/kegbot')
    $bind          = hiera('kegbot::bind',          '0.0.0.0:8000')
    $config_file   = hiera('kegbot::config_file',   "${config_dir}/config.gflags")
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

    # kegbot:database
    $database_name = hiera('kegbot::database_name', 'kegbot')
    $database_type = hiera('kegbot::database_type', 'mysql')
    $kegbot_usr    = hiera('kegbot::kegbot_usr',    'ketbot')
    $kegbot_pwd    = hiera('kegbot::kegbot_pwd',    'beerMe123')

    $db_root_usr   = hiera('kegbot::db_root_usr',   'root')
    $db_root_pwd   = hiera('kegbot::db_root_pwd',   'beerMysql123')
    $mysql_packages  = []
    $sqlite_packages = [
        'python-sqlite'
    ]

    # kegbot:extras
    $install_sentry        = hiera('kegbot::install_sentry', false)
    $sentry_url            = hiera('kegbot::sentry_url',     'http://foo:bar@localhost:9000/2')
    $install_debug_toolbar = hiera('kegbot::install_sentry', false)
    $install_statsd        = hiera('kegbot::install_sentry', false)
}
