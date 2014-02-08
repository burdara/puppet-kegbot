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
    $mysql_pwd       = $::kegbot::database::params::mysql_pwd,
    $mysql_packages  = $::kegbot::database::params::mysql_packages,
    $sqlite_packages = $::kegbot::database::params::sqlite_packages
) inherits kegbot::database::params 
{
    include mysql
    include sqlite
    
    case $::kegbot::database_type {
        'mysql': {
            Class['mysql']
        }
        'sqlite': {
            Class['sqlite']
        }
        default: {
            fail("Unsupported database_type: ${::kegbot::database_type}. Kegbot currently only supports: sqlite, mysql")
        }
    }
}
