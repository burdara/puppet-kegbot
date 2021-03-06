# == Class: kegbot::extras::statsd
#
# Installs statsd
#
# === Parameters
#
# None
#
# === Variables
#
# [kegbot::install_dir]
#   server install directory
#
# === Authors
#
# Robbie Burda <github.com/burdara>
#
class kegbot::extras::statsd inherits kegbot::extras {
    $source_env_activate = "source ${::kegbot::install_dir}/bin/activate"
    $pip_statsd = "${::kegbot::install_dir}/bin/pip install django-statsd-mozilla"
    $install_command = "bash -c '${source_env_activate} && ${pip_statsd}'"
    exec { 'install-statsd':
        command => $install_command,
        timeout => 600,
    }
}
