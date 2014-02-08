# == Class: kegbot::database::params
#
# === Parameters
#
# === Variables
#
# === Examples
#
# === Authors
# Robbie Burda <github.com/burdara>
#
class kegbot::database::params {
    # database::mysql
    $mysql_pwd = hiera('kegbot::database::mysql_pwd', 'beerMysql123')
    $mysql_packages = [
        'mysql-server',
        'mysql-client'
    ]
    # database::sqlite
    $sqlite_packages = [
        'python-sqlite'
    ]
}
