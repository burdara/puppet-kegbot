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
  $instance_name            = $title,
  $install_source           = $::kegbot::params::default_install_source,
  $server_port              = $::kegbot::params::default_server_port,
  $debug_mode               = $::kegbot::params::default_debug_mode,
  $user                     = $::kegbot::params::default_kegbot_user,
  $group                    = $::kegbot::params::default_kegbot_group,
  $database_name            = $title,
  $database_root_user       = $::kegbot::params::default_database_root_user,
  $database_root_password   = $::kegbot::params::default_database_root_password,
  $database_kegbot_user     = $::kegbot::params::default_database_kegbot_user,
  $database_kegbot_password = $::kegbot::params::default_database_kegbot_password,
  $start_server             = $::kegbot::params::default_start_server_instance,
) {
  # The base class must be included first because it is used by parameter defaults
  if ! defined(Class['kegbot']) {
    fail('You must include the kegbot base class before using any kegbot defined resources')
  }

  $path = "${::kegbot::base_path}/${instance_name}"
  $config_path = "${::kegbot::base_path}/${instance_name}/config"
  $log_path = "${::kegbot::base_path}/${instance_name}/log"
  $data_path = "${::kegbot::data_base_path}/${instance_name}/data"
  $create_file_list = [$path, $config_path, $log_path]

  $config_file = "${config_path}/config.gflags"
  $config_data_root = "--data_root=${data_path}"
  $config_db_type = '--db_type=mysql'
  $config_db_database = "--db_database=${database_name}"
  $config_db_user = "--db_user=${database_kegbot_user}"
  $config_db_password = "--db_password=${database_kegbot_password}"
  $config_settings_dir = "--settings_dir=${config_path}"

  if $::kegbot::environment == 'prod' {
    $run_server_command = 'run_gunicorn --debug --bind'
  } else {
    $run_server_command = 'runserver'
  }

  $source_env_activate = "source ${path}/bin/activate"
  $setup_kegbot = "${path}/bin/setup-kegbot.py --flagfile=${config_file}"
  $setup_server_command = "bash -c '${source_env_activate} && ${setup_kegbot} &> ${log_path}/setup.log'"
  $run_server = "KEGBOT_SETTINGS_DIR=${config_path} ${path}/bin/kegbot ${run_server_command} 127.0.0.1:${server_port} &> ${log_path}/server.log &"
  $run_workers = "${path}/bin/kegbot run_workers &> ${log_path}/workers.log &"
  $start_server_command = "bash -c '${source_env_activate} && ${run_server}'"
  $start_run_workers_command = "bash -c '${source_env_activate} && ${run_workers}'"

  case $install_source {
    pip: {
      $installer = '::kegbot::install::pip'
    }
    github: {
      $installer = '::kegbot::install::github'
    }
    default: {
      fail("Unsupported install_src: ${install_source}. Module currently supports: pip, github")
    }
  }

  file { $create_file_list:
    ensure => directory,
    owner  => $user,
    group  => $group,
  }

  file { 'create_config_file':
      path    => $config_file,
      content => template('kegbot/config.gflags.erb'),
      owner   => $user,
      group   => $group,
      require => File[$config_path],
  }

  class { $installer:
    path    => $path,
    user    => $user,
    group   => $group,
  }

  class { '::kegbot::database::mysql':
    dbname          => $database_name,
    user            => $user,
    group           => $group,
    root_user       => $database_root_user,
    root_password   => $database_root_password,
    kegbot_user     => $database_kegbot_user,
    kegbot_password => $kegbot_password,
    before          => Exec['setup_server']
  }

  exec {
    'create_virtualenv':
      command => "virtualenv ${path}",
      creates => "${path}/bin/activate",
      user    => $user,
      group   => $group,
      require => [
        Exec['install_virtualenv'],
        File[$path],
      ];
    'setup_server':
      command => $setup_server_command,
      creates => $data_path,
      user    => $user,
      group   => $group,
      require => File['create_config_file'];
  }

  Exec['create_virtualenv'] ->
  Class[$installer] ->
  Exec['setup_server']

  if $start_server {
    exec {
      'start_server':
        command => $start_server_command,
        user    => $user,
        group   => $group,
        require => Exec['setup_server'];
      'start_workers':
        command => $start_run_workers_command,
        user    => $user,
        group   => $group,
        require => Exec['setup_server'];
    }
  }
}
