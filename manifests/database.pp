# == Class: kegbot::database
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
class kegbot::database (
    $mysql_pwd       = $::kegbot::params::mysql_pwd,
    $mysql_packages  = $::kegbot::params::mysql_packages,
    $sqlite_packages = $::kegbot::params::sqlite_packages
    ) {

    case $::kegbot::database_type {
        mysql: {
            include mysql
        }
        sqlite: {
            include sqlite
        }
        default: {
            fail("Unsupported database_type: ${::kegbot::database_type}. Kegbot currently only supports: sqlite, mysql")
        }
    }
}
