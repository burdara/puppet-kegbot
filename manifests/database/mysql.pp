# == Class: kegbot::database::mysql
#
# Installs mysql database
#
# === Parameters
#
# [*name*]
#   (namevar) database name
# [*user*]
#   primary server user
# [*group*]
#   primary server group
# [*root_user*]
#   MySql root user
# [*kegbot_password*]
#   MySql root password
# [*kegbot_user*]
#   Kegbot database username
# [*kegbot_password*]
#   Kegbot database password
#
# === Variables
#
# === Authors
#
# Robbie Burda <github.com/burdara>
# Tyler Walters <github.com/tylerwalts>
#
class kegbot::database::mysql (
  $dbname          = $::kegbot::params::default_database_name,
  $user            = $::kegbot::params::default_kegbot_user,
  $group           = $::kegbot::params::default_kegbot_group,
  $root_user       = $::kegbot::params::default_database_root_user,
  $root_password   = $::kegbot::params::default_database_root_password,
  $kegbot_user     = $::kegbot::params::default_database_kegbot_user,
  $kegbot_password = $::kegbot::params::default_database_kegbot_password,
){
  exec {
    'create_kegbot_db':
      command => "mysql --user=${root_user} --password=${root_password} -e 'create database ${dbname};' -sN",
      onlyif  => "test \$(mysql --user=${root_user} --password=${root_password} -e 'show databases;' -sN | grep -c '${dbname}') -eq 0",
      user    => $user,
      group   => $group;
    'create_kegbot_db_user':
      command => "mysql --user=${root_user} --password=${root_password} -e 'GRANT ALL PRIVILEGES ON ${dbname}.* to ${kegbot_user}@localhost IDENTIFIED BY \"${kegbot_password}\";' -sN",
      unless  => "mysql --user=${root_user} --password=${root_password} -e 'SHOW GRANTS FOR ${kegbot_user}@localhost;' -sN",
      user    => $user,
      group   => $group;
    'update_mysql_timezone_tables':
      command => "mysql_tzinfo_to_sql /usr/share/zoneinfo | mysql --user=${root_user} --password=${root_password} mysql",
      user    => $user,
      group   => $group;
  }

  Exec['create_kegbot_db'] ->
  Exec['create_kegbot_db_user'] ->
  Exec['update_mysql_timezone_tables']
}
