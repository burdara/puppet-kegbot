# == Class: kegbot::database::mysql
#
# Installs mysql database
#
# === Parameters
#
# === Variables
#
# [kegbot::params::database_name]
#   Kegbot database name
# [kegbot::params::kegbot_usr]
#   Kegbot username
# [kegbot::params::kegbot_pwd]
#   Kegbot password
# [kegbot::params::db_root_usr]
#   MySql root user
# [kegbot::params::db_root_pwd]
#   MySql root password
#
# === Authors
#
# Robbie Burda <github.com/burdara>
# Tyler Walters <github.com/tylerwalts>
#
class kegbot::database::mysql {
  contain kegbot

  service{ 'mysql':
    ensure     => running,
    enable     => true,
    hasstatus  => true,
    hasrestart => true,
    require    => Package['mysql-server'],
  }

  exec {
    'set_root_pwd':
      command     => "mysqladmin --user=${db_root_usr} password ${db_root_pwd}",
      subscribe   => Package['mysql-server'],
      refreshonly => true;
    'create_kegbot_db':
      command => "mysql --user=${db_root_usr} --password=${db_root_pwd} -e 'create database kegbot;' -sN",
      onlyif  => "test \$(mysql --user=${db_root_usr} --password=${db_root_pwd} -e 'show databases;' -sN | grep -c '${database_name}') -eq 0";
    'create_kegbot_db_user':
      command => "mysql --user=${db_root_usr} --password=${db_root_pwd} -e 'GRANT ALL PRIVILEGES ON kegbot.* to ${kegbot_usr}@localhost IDENTIFIED BY \"${kegbot_pwd}\";' -sN",
      unless  => "mysql --user=${db_root_usr} --password=${db_root_pwd} -e 'SHOW GRANTS FOR ${kegbot_usr}@localhost;' -sN";
  }

  Service['mysql'] ->
  Exec['set_root_pwd'] ->
  Exec['create_kegbot_db'] ->
  Exec['create_kegbot_db_user']
}
