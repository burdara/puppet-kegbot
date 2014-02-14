# == Class: kegbot::database
#
# Installs database for server
#
# === Parameters
#
# [db_root_pwd]
#   Database root password
# [mysql_packages]
#   MySql database packages
# [sqlite_packages]
#   Sqlite database packages
#
# === Variables
#
# [kegbot::database_type]
#   Database type for kegbot backend database
#
# === Authors
#
# Robbie Burda <github.com/burdara>
# Tyler Walters <github.com/tylerwalts>
#
class kegbot::database (
    $db_root_pwd     = $::kegbot::params::db_root_pwd,
    $mysql_packages  = $::kegbot::params::mysql_packages,
    $sqlite_packages = $::kegbot::params::sqlite_packages
) {
    case $::kegbot::database_type {
        mysql: {
            include database::mysql
        }
        sqlite: {
            include database::sqlite
        }
        default: {
            fail("Unsupported database_type: ${::kegbot::database_type}. Kegbot currently only supports: sqlite, mysql")
        }
    }
}
