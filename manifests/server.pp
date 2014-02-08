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

    $source_env_activate = "source ${::kegbot::install_dir}/bin/activate"

    file { ${::kegbot::log_dir}:
        ensure => directory
    }
    # start server
    $run_server = "${::kegbot::install_dir}/bin/kegbot runserver ${::kegbot::bind} &> ${::kegbot::log_dir}/server.log &"
    $start_server_command = "${source_env_activate} && ${run_server}"
    exec { 'start-server':
        command => $start_server_command,
        require => File[$::kegbot::log_dir]
    }

    $start_celeryd_command = "${source_env_activate} && ${::kegbot::install_dir}/bin/kegbot celeryd_detach -E"
    exec { 'start-celeryd':
        command => $start_celeryd_command,
        require => Exec['start-server']
    }
}
