# == Class: kegbot::database::sqlite
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
class kegbot::database::sqlite {

    $packages = [
        'python-sqlite'
    ]

    exec { $packages: 
        ensure => latest
    }
}
