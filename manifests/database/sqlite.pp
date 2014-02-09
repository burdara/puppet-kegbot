# == Class: kegbot::database::sqlite
#
#  This will install the sqlite package to support kegbot
#
# === Parameters
#
# None
#
# === Variables
#
# [kegbot::database::sqlite_packages]
#   Sqlite packages
#
# === Authors
#
# Robbie Burda <github.com/burdara>
# Tyler Walters <github.com/tylerwalts>
#
class kegbot::database::sqlite {
    package { $::kegbot::database::sqlite_packages:
        ensure => latest
    }
}
