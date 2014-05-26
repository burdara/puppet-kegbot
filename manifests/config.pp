# == Class: kegbot:config
#
# Creates kegbot config files
#
# === Parameters
#
# === Variables
#
# [kegbot::install_dir]
#   Install directory for server
# [kegbot::config_dir]
#   Config directory for server
# [kegbot::config_file]
#   Config file for server setup
#
# === Authors
#
# Robbie Burda <github.com/burdara>
# Tyler Walters <github.com/tylerwalts>
#
class kegbot::config {
  contain kegbot
  
  if $::kegbot::data_dir {
    $data_root = "--data_root=${::kegbot::data_dir}"
  }
  if $::kegbot::database_type {
    $db_type = "--db_type=${::kegbot::database_type}"
  }
  if $::kegbot::database_name {
    $db_database = "--db_database=${::kegbot::database_name}"
  }
  if $::kegbot::kegbot_usr {
    $db_user = "--db_user=${::kegbot::kegbot_usr}"
  }
  if $::kegbot::kegbot_pwd {
    $db_password = "--db_password=${::kegbot::kegbot_pwd}"
  }
  if $::kegbot::config_dir {
    $settings_dir = "--settings_dir=${::kegbot::config_dir}"
  }

  file {
    'create_install_dir':
      ensure  => directory,
      path    => $::kegbot::install_dir;
    'create_config_dir':
      ensure  => directory,
      path    => $::kegbot::config_dir;
    'create_config_file':
      path    => $::kegbot::config_file,
      content => template('kegbot/config.gflags.erb');
  }

  File['create_config_dir'] ->
  File['create_config_file']
}
