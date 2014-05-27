# == Class: kegbot::database
#
# Installs database for server
#
# === Parameters
#
# [kegbot::database_type]
#   Database type for kegbot backend database
#
# === Variables
#
# === Authors
#
# Robbie Burda <github.com/burdara>
# Tyler Walters <github.com/tylerwalts>
#
class kegbot::database {
  contain kegbot

  case $::kegbot::database_type {
    mysql: {
      contain kegbot::database::mysql
    }
    postgres: {
      contain kegbot::database::postgres
    }
    default: {
      fail("Unsupported database_type: ${::kegbot::database_type}. Module currently supports: mysql, postgres")
    }
  }
}
