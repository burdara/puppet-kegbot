# == Class: kegbot::server
#
# Starts server and other server components
#
# === Parameters
#
# === Variables
#
# [kegbot::install_dir]
#   Install directory for server
# [kegbot::bind]
#   Binding IP address and port for server
# [kegbot::log_dir]
#   Log directory for server
#
# === Authors
#
# Robbie Burda <github.com/burdara>
# Tyler Walters <github.com/tylerwalts>
#
class kegbot::server {
  contain kegbot

  $source_env_activate = "source ${::kegbot::install_dir}/bin/activate"
  $run_server = "${::kegbot::install_dir}/bin/kegbot runserver ${::kegbot::bind} &> ${::kegbot::log_dir}/server.log &"
  $start_server_command = "bash -c '${source_env_activate} && ${run_server}'"
  $start_run_workers_command = "bash -c '${source_env_activate} && ${::kegbot::install_dir}/bin/kegbot run_workers &> ${::kegbot::log_dir}/workers.log &'"

  file { 'create_log_dir':
    ensure => directory,
    path   => $::kegbot::log_dir,
  }

  exec {
    'start_server':
      command => $start_server_command;
    'start_workers':
      command => $start_run_workers_command;
  }

  File['create_log_dir'] ->
  Exec['start_server'] ->
  Exec['start_workers']
}
