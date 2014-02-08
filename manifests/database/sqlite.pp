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
    exec { ${::kegbot::database::sqlite_packages}: 
        ensure => latest
    }
}
