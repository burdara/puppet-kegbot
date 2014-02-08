# == Class: kegbot:config
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
class kegbot::config {
    file {
        'create_config_dir':
            path   => $::kegbot::config_dir,
            ensure => directory;
        'create_config_file':
            path   => $::kegbot::config_file,
            content => template('kegbot/config.gflags.erb');
    }

    File['create_config_dir'] ->
    File['create_config_file']
}
