# == Class: kegbot::server
#
# Starts server and other server components
#
# === Parameters
#
# None
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
class kegbot::server inherits kegbot {
    # Set default exec path for this module
    Exec { path => ['/usr/bin', '/usr/sbin', '/bin'] }

    $source_env_activate = "source ${::kegbot::install_dir}/bin/activate"
    # start server
    $run_server = "${::kegbot::install_dir}/bin/kegbot runserver ${::kegbot::bind} &> ${::kegbot::log_dir}/server.log &"
    $start_server_command = "bash -c '${source_env_activate} && ${run_server}'"
    # start celeryd
    $start_celeryd_command = "bash -c '${source_env_activate} && ${::kegbot::install_dir}/bin/kegbot celeryd_detach -E'"

    file { 'create_log_dir':
        ensure => directory,
        path   => $::kegbot::log_dir,
    }

    exec {
        'start_server':
            command => $start_server_command;
        'start_celeryd':
            command => $start_celeryd_command;
    }

    File['create_log_dir'] ->
    Exec['start_server'] ->
    Exec['start_celeryd']
}
