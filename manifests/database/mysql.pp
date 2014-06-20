# == Define Type: kegbot::database::mysql
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
define kegbot::database::mysql (
  $database_name            = $::kegbot::params::default_database_name,
  $database_root_user       = $::kegbot::params::default_database_root_user,
  $database_root_password   = $::kegbot::params::default_database_root_password,
  $database_kegbot_user     = $::kegbot::params::default_database_kegbot_user,
  $database_kegbot_password = $::kegbot::params::default_database_kegbot_password,
){
  exec {
    'create_kegbot_db':
      command => "mysql --user=${database_root_user} --password=${database_root_password} -e 'create database ${database_name};' -sN",
      onlyif  => "test \$(mysql --user=${database_root_user} --password=${database_root_password} -e 'show databases;' -sN | grep -c '${database_name}') -eq 0",
      user    => $::kegbot::user,
      group   => $::kegbot::group;
    'create_kegbot_db_user':
      command => "mysql --user=${database_root_user} --password=${database_root_password} -e 'GRANT ALL PRIVILEGES ON kegbot.* to ${database_kegbot_user}@localhost IDENTIFIED BY \"${database_kegbot_password}\";' -sN",
      unless  => "mysql --user=${database_root_user} --password=${database_root_password} -e 'SHOW GRANTS FOR ${database_kegbot_user}@localhost;' -sN",
      user    => $::kegbot::user,
      group   => $::kegbot::group;
    'update_mysql_timezone_tables':
      command => "mysql_tzinfo_to_sql /usr/share/zoneinfo | mysql --user=${database_root_user} --password=${database_root_password} mysql",
      user    => $::kegbot::user,
      group   => $::kegbot::group;
  }

  Exec['create_kegbot_db'] ->
  Exec['create_kegbot_db_user'] ->
  Exec['update_mysql_timezone_tables']
}
