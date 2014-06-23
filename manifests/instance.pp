# == Define Type: kegbot::install
#
# Installs server and other server components
#
# === Parameters
#
# [*name*]
#   (namevar) name of instance
# [*install_source*]
#   server install from source (pip or github)
# [*server_port*]
#   server port
# [*debug_mode*]
#   set server debug_mode
# [*user*]
#   instance server user
# [*group*]
#   instance server group
# [*database_name*]
#   server database name
# [*database_root_user*]
#   server database root user
# [*database_root_password*]
#   server database root password
# [*database_kegbot_user*]
#   server applicaton database user
# [*database_kegbot_password*]
#   server applicaton database password
#
# === Variables
#
# === Authors
#
# Robbie Burda <github.com/burdara>
# Tyler Walters <github.com/tylerwalts>
#
define kegbot::instance (
  $name                     = $title,
  $install_source           = $::kegbot::params::default_install_source,
  $server_port              = $::kegbot::params::default_server_port,
  $debug_mode               = $::kegbot::params::default_debug_mode,
  $user                     = $::kegbot::params::default_kegbot_user,
  $group                    = $::kegbot::params::default_kegbot_group,
  $database_name            = $::kegbot::params::default_database_name,
  $database_root_user       = $::kegbot::params::default_database_root_user,
  $database_root_password   = $::kegbot::params::default_database_root_password,
  $database_kegbot_user     = $::kegbot::params::default_database_kegbot_user,
  $database_kegbot_password = $::kegbot::params::default_database_kegbot_password,
) {
  contain ::kegbot

  $path = "${::kegbot::base_path}/${name}"
  $data_path = "${::kegbot::base_path}/${name}/data"
  $config_path = "${::kegbot::base_path}/${name}/config"
  $log_path = "${::kegbot::base_path}/${name}/log"

  $config_data_root = "--data_root=${data_path}"
  $config_db_type = '--db_type=mysql'
  $config_db_database = "--db_database=${database_name}"
  $config_db_user = "--db_user=${database_kegbot_user}"
  $config_db_password = "--db_password=${database_kegbot_password}"
  $config_settings_dir = "--settings_dir=${config_path}"

  file { [ $path, $data_path, $config_path, $log_path ]:
    ensure => directory,
    owner  => $user,
    group  => $group,
  }

  exec { 'create_virtualenv':
    command => "virtualenv ${path}",
    creates => "${path}/bin/activate",
    user    => $user,
    group   => $group,
    require => [
      Exec['install_virtualenv'],
      File[$path],
    ]
  }

  $config_file = "${config_path}/config.gflags"
  file { 'create_config_file':
      path    => $config_file,
      content => template('kegbot/config.gflags.erb'),
      owner   => $user,
      group   => $group,
      require => File[$config_path],
  }

  case $install_source {
    pip: {
      include kegbot::install::pip
      $install_class = '::kegbot::install::pip'
    }
    github: {
      include kegbot::install::github
      $install_class = '::kegbot::install::github'
    }
    default: {
      fail("Unsupported install_src: ${install_source}. Module currently supports: pip, github")
    }
  }

  contain ::kegbot::database::mysql

  $source_env_activate = "source ${path}/bin/activate"
  $setup_kegbot = "${path}/bin/setup-kegbot.py --flagfile=${config_file}"
  $setup_server_command = "bash -c '${source_env_activate} && ${setup_kegbot}'"
  $run_server = "${path}/bin/kegbot runserver 0.0.0.0:${server_port} &> ${log_path}/server.log &"
  $run_workers = "${path}/bin/kegbot run_workers &> ${log_path}/workers.log &"
  $start_server_command = "bash -c '${source_env_activate} && ${run_server}'"
  $start_run_workers_command = "bash -c '${source_env_activate} && ${run_workers}'"
  exec {
    'setup_server':
      command => $setup_server_command,
      creates => $::kegbot::data_dir,
      require => File['create_config_file']
    'start_server':
      command => $start_server_command;
    'start_workers':
      command => $start_run_workers_command;
  }

  Exec['create_virtualenv'] ->
  Class[$install_class] ->
  Exec['setup_server'] ->
  Exec['start_server'] ->
  Exec['start_workers']
}
