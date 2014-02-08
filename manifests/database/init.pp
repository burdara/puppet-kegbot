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
class kegbot::database {
    include mysql
    include sqlite
    
    case $::kegbot::database {
        'mysql': {
            Class['mysql']
        }
        'sqlite': {
            Class['sqlite']
        }
        default: {
            fail("Unsupported database: ${::kegbot::database}. Kegbot currently only supports: sqlite, mysql")
        }
    }
}
