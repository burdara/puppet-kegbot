# == Class: kegbot::database::sqlite
#  This will install the sqlite package to support kegbot
class kegbot::database::sqlite {
    package { "${::kegbot::sqlite_packages}":
        ensure => latest
    }
}
