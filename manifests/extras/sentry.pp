# == Class: kegbot::extras::sentry
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
class kegbot::extras::sentry (
    $install_dir = hiera('kegbot::install_dir' '/opt/kegbot'),
    $sentry_url  = hiera('kegbot::sentry_url', 'http://foo:bar@localhost:9000/2')
    ){

    # Set default exec path for this module
    Exec { path => ['/usr/bin', '/usr/sbin', '/bin'] }

    $source_env_activate="source $install_dir/bin/activate"
    $install_command = "$source_env_activate && $install_dir/bin/pip install raven"
    exec { 'install-raven':
        command => $install_command,
        timeout => 600
    }

    # TODO path?
    $local_settings="TODO/local_settings.py"
    file { 'local-settings':
        path    => $local_settings,
        content => template("kegbot/local_settings.py.erb"),
        require => File['install-raven']
    }
}
