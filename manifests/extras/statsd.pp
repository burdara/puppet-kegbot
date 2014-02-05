# == Class: kegbot::extras::statsd
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
class kegbot::extras::statsd (
    $install_dir = hiera('kegbot::install_dir' '/opt/kegbot')
    ){

    # Set default exec path for this module
    Exec { path => ['/usr/bin', '/usr/sbin', '/bin'] }

    $source_env_activate="source $install_dir/bin/activate"
    $install_command = "$source_env_activate && $install_dir/bin/pip install django-statsd-mozilla"
    exec { 'install-statsd':
        command => $install_command,
        timeout => 600
    }
}
