# == Class: kegbot::server
#
# === Parameters
#
# === Variables
#
# === Examples
#
# === Authors
# Robbie Burda <github.com/burdara>
#
class kegbot::server {
    # Set default exec path for this module
    Exec { path => ['/usr/bin', '/usr/sbin', '/bin'] }

    $source_env_activate = "source. ${::kegbot::install_dir}/bin/activate"

    file { 'create_log_dir':
        path   => "$kegbot::log_dir",
        ensure => directory
    }

    # start server
    $run_server = "${::kegbot::install_dir}/bin/kegbot runserver ${::kegbot::bind} &> ${::kegbot::log_dir}/server.log &"
    $start_server_command = "bash -c '${source_env_activate} && ${run_server}'"
    # start celeryd
    $start_celeryd_command = "bash -c '${source_env_activate} && ${::kegbot::install_dir}/bin/kegbot celeryd_detach -E'"

    exec {
        'start_server':
            command => $start_server_command,
            require => File[$::kegbot::log_dir];
        'start_celeryd':
            command => $start_celeryd_command,
            require => Exec['start_server'];
    }

    File['create_log_dir'] ->
    Exec['start_server'] ->
    Exec['start_celeryd']
}
