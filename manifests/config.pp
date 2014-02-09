# == Class: kegbot:config
#
# Creates kegbot config files
#
# === Parameters
#
# None
#
# === Variables
#
# [kegbot::config_dir]
#   Config directory for server
# [kegbot::config_file]
#   Config file for server setup
#
# === Authors
#
# Robbie Burda <github.com/burdara>
# Tyler Walters <github.com/tylerwalts>
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
